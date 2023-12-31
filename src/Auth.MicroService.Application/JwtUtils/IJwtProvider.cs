﻿using Auth.MicroService.Domain.Entities;
using Auth.MicroService.Domain.Enums;

namespace Auth.MicroService.Application.JwtUtils
{
    public interface IJwtProvider
    {
        string GenerateJwt(User user);
        string GeneratePasswordResetToken(User user);
        bool ValidateToken(string token);
        string ValidatePasswordResetToken(string token);
        int? GetUserIdFromToken(string token);
        Role? GetUserRoleFromToken(string token);
    }
}
