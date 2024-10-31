Return-Path: <ceph-devel+bounces-1993-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0979B865B
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Oct 2024 23:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7612C282EE9
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Oct 2024 22:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1663C1EC019;
	Thu, 31 Oct 2024 22:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GU2KDx1d"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24161D131F
	for <ceph-devel@vger.kernel.org>; Thu, 31 Oct 2024 22:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415231; cv=none; b=UlgidgVII18oRB6ThB6hUVl0e9tJfmm2s5mTM8yaH4hZxvXj2tfP/w98z5GkCIrfI9QfYzqM0LtSXOGTAUd7aE4XWBBBGpJRSlxVKTiG58Sbiyb3h8Vga7ykGMDuc36oh9ObE5r1EH3pgr/vdovlyFd+9yo9I9gFRBsPiXLmg60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415231; c=relaxed/simple;
	bh=pHBg4ejpLx5lEeUtxj625TCmYLloW71G3t7gl4zIiNc=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=rfiWhCKDVodefCeeYnF9S9ZgEYzU/5SYTjFWyPdr3fkRnZEQlruwZ4wycIEPT3bDRCQbsIzuBhMi6OhhPi03dMXO+kle3lUT1hvimS1HAddFi2kRe2LXQLdRWSyT3ugjoZloqynNmYkpIiT9jYd/Wq35jlH0wCzpElWI4m3XtWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GU2KDx1d; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-46101120e70so9574111cf.1
        for <ceph-devel@vger.kernel.org>; Thu, 31 Oct 2024 15:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1730415221; x=1731020021; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udTVBIR/QeqJ5ZiBMjmwgfafaCOXQDv85YKhtLP6cZI=;
        b=GU2KDx1d5dARQcuOS0sW00oJIoutfiKIOAAIaJwXL1C263gPow7ZkE1eSKpnTNKkO1
         R86yd5vTKtDC+79sdTvo+X8wXcbCpcmDGOLg14r/TgWtElaoJVl4gA+fetLAyI8j+Kb9
         j5f2EnbTnhcHN77GwJQd4cE4D/NjekIDjc+R2BcljHCpT1Rs6mCkeuTeeI3ZpPtoJmIx
         2yZU7cbY6/eVACESD0PGuLD5d6Pnn9/HiFiF30jmBl1CYEhrk/BX7x0pStMuQQoC/1k7
         fezmZZO6rZ00vp+NSDdo1XIhstpWomKyodHeAVwh7nTXEWEDLRZQmJpmuVCqp02HTU0M
         WOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730415221; x=1731020021;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=udTVBIR/QeqJ5ZiBMjmwgfafaCOXQDv85YKhtLP6cZI=;
        b=lBPutd/+8AGk392wWd0Qw5NnNXLJwOYQ1Ditl3Qx1oe6tfJ9zfpWvaGt1q1bziYhsw
         vw2YVY+T6O4ij3TbHqh3gR2alsdLERH4zRV2BG519iLdTrIxez6uAy+95xeloU2xmxIM
         A+/D90C+bnOfC3cBUMrMms4KzOCFeXS78h43CGuDDQ2gOHDCJGprLFBjbhkHdZz6c47U
         +mLDJvNtfDEKtL8sWNMmeibv025PoPF279ww2PCHud2RhbWrPnM07rtujMomYSdkAIWB
         omy8NEFMrzDlBsOKgt2vei2IlOITP+anys6RikLdCtgOzWgEhHDbp+yvqDlXubqe0UHx
         ZKcA==
X-Forwarded-Encrypted: i=1; AJvYcCXdAyFMXllgefpEDBe6vEgoMCVpGhTqW60ZoKVU3OysxSPBPAgZdX+2bnAhXNuNTGi72tgrHhyuqAcK@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1fRQ/ncqcl5RH2jkkx545Dbwkd4noVGKPxNrnjHCWzhHEE+uM
	kHxIlwTPqWWXGSypVg8swRkQvFBYYx268XyQd9PHSUkweCw5ZeXIT7SdabCpNw==
X-Google-Smtp-Source: AGHT+IG4RK7zrIqYSfQlaLi2Jn/fcR7Wi85MclzKEW7ddmJvzAaqeYWrXlsvLQLcYYERuWLiK1/Vvg==
X-Received: by 2002:a05:622a:188c:b0:460:e7f5:1bf with SMTP id d75a77b69052e-461717c4602mr103322611cf.51.1730415221615;
        Thu, 31 Oct 2024 15:53:41 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ad1a12b4sm12324511cf.82.2024.10.31.15.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 15:53:41 -0700 (PDT)
Date: Thu, 31 Oct 2024 18:53:40 -0400
Message-ID: <6c1de7c79141034433d6eab515bcef43@paul-moore.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20241031_1534/pstg-lib:20241031_1459/pstg-pwork:20241031_1534
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>, casey@schaufler-ca.com, linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, serge@hallyn.com, keescook@chromium.org, john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp, stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org, selinux@vger.kernel.org, mic@digikod.net, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v3 4/5] LSM: lsm_context in security_dentry_init_security
References: <20241023212158.18718-5-casey@schaufler-ca.com>
In-Reply-To: <20241023212158.18718-5-casey@schaufler-ca.com>

On Oct 23, 2024 Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> Replace the (secctx,seclen) pointer pair with a single lsm_context
> pointer to allow return of the LSM identifier along with the context
> and context length. This allows security_release_secctx() to know how
> to release the context. Callers have been modified to use or save the
> returned data from the new structure.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: linux-nfs@vger.kernel.org
> ---
>  fs/ceph/super.h               |  3 +--
>  fs/ceph/xattr.c               | 16 ++++++----------
>  fs/fuse/dir.c                 | 35 ++++++++++++++++++-----------------
>  fs/nfs/nfs4proc.c             | 20 ++++++++++++--------
>  include/linux/lsm_hook_defs.h |  2 +-
>  include/linux/security.h      | 26 +++-----------------------
>  security/security.c           |  9 ++++-----
>  security/selinux/hooks.c      |  9 +++++----
>  8 files changed, 50 insertions(+), 70 deletions(-)

See my note on patch 1/5, merging into lsm/dev.

--
paul-moore.com

