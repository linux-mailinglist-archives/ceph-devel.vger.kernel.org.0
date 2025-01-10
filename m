Return-Path: <ceph-devel+bounces-2424-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F79CA085C8
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 04:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 396663A90E7
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 03:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C031A4F1F;
	Fri, 10 Jan 2025 03:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iIaR3zQr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F72942A
	for <ceph-devel@vger.kernel.org>; Fri, 10 Jan 2025 03:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736478731; cv=none; b=aHL1hdy/SWM/b0FtDV04XeiISf1ZL0h8DdJvqb/vgiUgIXlYTKLVqImG1uzzC2BVUyCQYEn0DUiezOnhN83Y+DvXttXWXtAcc92/DjpEqHGcD7uZ8ZuQvlaLAIg71aviyXIZiw+nUZeCqaANSabJIuVSxp0KT9TEelHop1zET+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736478731; c=relaxed/simple;
	bh=D18utRlVGGzPCuWewtrj5krIU9bJrmplcMeXiRT1+TY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=atgC8ZnjqMDOncog8k0rQb4ZaCp4Ok1SiXhaHpNvIaE4sLjKkKDg1MtcP6FYwxLGCDAko44rEboHKIqLM57DeGRZ1rnQwHwKiLLsAsgVe/scobUgo6rba8OVj8fXUYA6WvjpkWrHYphKzskPzoYPbqyBsW6JP02tYK4Sh0wtGcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iIaR3zQr; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d88c355e0dso2651837a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jan 2025 19:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1736478726; x=1737083526; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M1QMtuuDrMek+cqp6TB29HWYKAOWii4BW9zvMrbHJAk=;
        b=iIaR3zQr9AEjbZm4QgIkpIovhvlGfB/Pvp7eIl4rhPekf8k+6cNzGuD1i91pyFqPHt
         rosrpVTUU4L4xFDsln+TO5MwcnFgobiUJGZLLgFtIcKt/xir8KOfpZ9CCwY2hRSIcW02
         zY2cgbU/6w1qu+h0RNS6PpYETzIxO0+Lw8nGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736478726; x=1737083526;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1QMtuuDrMek+cqp6TB29HWYKAOWii4BW9zvMrbHJAk=;
        b=V32AUmd69ynlVkOBiG2uXARGLQ5mH7C3BVLymqrCfIm0cNFNQBhTCIcAVuUUHjmlsU
         XtHpSMOrPdG2Y0SzakH84RBYhPsQOZxbid/k3l8AfMRLOwfDpb/HwLLYvOzBtojxVW96
         1yEQFrlkbZu5DwNiJ+K+v1c8UQIxB2j3p1I3qmaqI5v3WldpPC833xnsPxzQmcbMTPnf
         mOD0sBRqfZhUJzoqim8CGnM8A1YAqFGVCJ9faxc+1g09Yu915dhXbdL2CYxeaUgG9KgD
         iIKgbWoWzPh7kAiNz7/yON48+gIjrmAD/Ty5tjxs43nOZV9HoSan00L1+/XwJeiLbvBE
         mf/w==
X-Forwarded-Encrypted: i=1; AJvYcCVndu8Han7Q65LZCVIXi4SxkcDk0sgPPl90Kw06JZsJ1vbyeOQoZ1nSnzkXi+3tfb4QLslft37kqd+l@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/CyWsI5c/OffGidxLH/D+qwg3OPP9YY7c5U8HYvBX4UDSW3RD
	6/Hu4yK8R9DmDfABBcsHHxREc8mx3Dcfq0Ti7hYCi+641gqHrPP8AapFh1AR1436Ak9V58ysuGo
	17wApTA==
X-Gm-Gg: ASbGncsip17kBIgFQVjlw/9P/jGM+J/ORlH5SaMXypuL0mLY0Oj7KgdmDWydWXCa1iW
	o4w54waChxlU2ykFXpc43hRLlnvZUyNLaA98a7AkFldBHP337ANX0UVVO8mg1mE0SIWrZSHyQgl
	53KY6uuUS3rPN8fshEtEQVhVDxTjyAkFFBW5WRnAM+kKXKwMT98z3FYG8g0kI/GUtZK7LW1MJ2A
	likVCcikVy5XV+GeTxAtypSG7TyzS1Jwd7HxEP7A1IG6IX1W1RwEFtu5Jy8ma3M7FF1i2iS3XNa
	TdapdLHPmeewOe7WxIF0GhGXUaXkSEc=
X-Google-Smtp-Source: AGHT+IFyrJZ2ofr3sMJOf0larMCO2gJP06nIiLM9XOtvkoKv1VG4g+ABQ/8MHBuiLkqxiMDYkjmVQA==
X-Received: by 2002:a17:907:a0cf:b0:ab2:b77e:f421 with SMTP id a640c23a62f3a-ab2b77ef683mr670272566b.23.1736478726407;
        Thu, 09 Jan 2025 19:12:06 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95647absm124562466b.118.2025.01.09.19.12.04
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 19:12:04 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso325662166b.2
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jan 2025 19:12:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX0ZJnkRus/t8WeUtXCt75XcG0qxAvotNOnE4Rps7O24jEEE6UtiIHTbuGunpLN2zMMd5WjqXQHflcm@vger.kernel.org
X-Received: by 2002:a17:907:7f24:b0:aa6:5eae:7ece with SMTP id
 a640c23a62f3a-ab2abc93e22mr778679366b.43.1736478723770; Thu, 09 Jan 2025
 19:12:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110023854.GS1977892@ZenIV> <20250110024303.4157645-1-viro@zeniv.linux.org.uk>
 <20250110024303.4157645-20-viro@zeniv.linux.org.uk>
In-Reply-To: <20250110024303.4157645-20-viro@zeniv.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jan 2025 19:11:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh2i3j3GUYpiTBteS7Ln02endudZCqc9DRz==3p8T__yQ@mail.gmail.com>
X-Gm-Features: AbW1kvZaQx4RZA3DoPNnn7ySYeCUxXnMhPsF3e4Ed8oCi4wmKUNd_tb4o7KrlrQ
Message-ID: <CAHk-=wh2i3j3GUYpiTBteS7Ln02endudZCqc9DRz==3p8T__yQ@mail.gmail.com>
Subject: Re: [PATCH 20/20] 9p: fix ->rename_sem exclusion
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, agruenba@redhat.com, amir73il@gmail.com, 
	brauner@kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com, 
	hubcap@omnibond.com, jack@suse.cz, krisman@kernel.org, 
	linux-nfs@vger.kernel.org, miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Jan 2025 at 18:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> However, to reduce dentry_operations bloat, let's add one method instead -
> ->d_want_unalias(alias, true) instead of ->d_unalias_trylock(alias) and
> ->d_want_unalias(alias, false) instead of ->d_unalias_unlock(alias).

Ugh.

So of all the patches, this is the one that I hate.

I absolutely detest interfaces with random true/false arguments, and
when it is about locking, the "detest" becomes something even darker
and more visceral.

I think it would be a lot better as separate ops, considering that

 (a) we'll probably have only one or two actual users, so it's not
like it complicates things on that side

 (b) we don't have *that* many "struct dentry_operations" structures:
I think they are all statically generated constant structures
(typically one or two per filesystem), so it's not like we're saving
memory by merging those pointers into one.

Please?

           Linus

