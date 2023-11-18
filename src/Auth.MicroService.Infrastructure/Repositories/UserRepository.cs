﻿using Auth.MicroService.Application.Models;
using Auth.MicroService.Domain.Entities;
using Auth.MicroService.Domain.Repositories;
using Auth.MicroService.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Auth.MicroService.Infrastructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly AuthDbContext _authDbContext;

        public UserRepository(AuthDbContext authDbContext)
        {
            _authDbContext = authDbContext;
        }

        public async Task AddNewUser(User user, CancellationToken ct)
        {
            await _authDbContext.Set<User>().AddAsync(user, ct);
            await _authDbContext.SaveChangesAsync(ct);
        }

        public async Task<User> GetUserByEmail(string email, CancellationToken ct)
        {
            return await _authDbContext.Set<User>()
                .AsNoTracking()
                .SingleOrDefaultAsync(u => u.Email == email, ct);
        }

        public async Task<IEnumerable<UserInfo>> GetAllInactiveUsers(CancellationToken ct)
        {
            return await _authDbContext.Set<User>()
                .AsNoTracking()
                .Where(u => u.Status == false)
                .Select(u => new UserInfo
                {
                    UserId = u.UserId.Value,
                    UserFullName = u.FirstName + u.LastName,
                    Email = u.Email,
                })
                .ToListAsync(ct);
        }
    }
}