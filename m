Return-Path: <ceph-devel+bounces-1511-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A55D92CCB3
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 10:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB5F81C21451
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 08:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09D984E14;
	Wed, 10 Jul 2024 08:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUY4IW3L"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67B92B9DD;
	Wed, 10 Jul 2024 08:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720599457; cv=none; b=V5YGT43lLHu7UdeEgBbMNXcO8mKMYVwFZzQ8NIc9Yj1gg0r4yO1+V+mofbhHzlJ8t7k1m1zFT3tPFcmn86BmHQQBfwLmOr99lLq8lqKm3XW9dZNl+W3zRijTpYU9w5B+Tv+6MDMGy/5nKLfTj3kDE2LSvWhY9YFY/eeTkOYB0Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720599457; c=relaxed/simple;
	bh=QL7gXfmn3sHEwdX5L7XIswSOUs7PLUJi/MBJBtdrt+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GIxo1XBpPmGcC29DtS/3O0LczN6r/z4ujUj7O8xeZyK0TiadMZkTs/AjZXHMITAyI8LaauI4gLeWlkuN3Ju2sKAQKT0zcK7E5VQwa9iWudo61p1D/MRJsryWevTuSUay0QZvKnK6WAk9Elv0bnElrwFr8TlUUyTDWNW5QN/nLrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUY4IW3L; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5c6924f2383so790914eaf.2;
        Wed, 10 Jul 2024 01:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720599455; x=1721204255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eEpPXs/xVI0eqBmePk09QmlwebuqlY4VOlxdZ0TFkAo=;
        b=iUY4IW3L4mrbg4xUvZCfL5f1CbnwffUuTRfM8D1G62Yb3tGAE2FLIFVzSwonV4ZHbz
         LVh0UXFg4nqXnyZC0f37zO0g20fab9UyiME5gsTIZGPqPVib8VhFfjTPUrNCb/SB5LdW
         AL04o44IBMqWffP1X+kvX21Ht83BqMFk7fYuypHU22xPLVHhNljcheu8KGG05r0ImjSd
         xR9XEMcIvuQz1O2fV7tTZEQhNUzcroO/DztflGgmD0rwajBzRp3/JKBZVQ3FTOFYDvOc
         rOgKyLMrQKU2CkYGOudoQMpzzDY6cvAZ/SWzBdmrc5RdeCOiNNsoO/5Tsz4V3FLxTV5Z
         OO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720599455; x=1721204255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eEpPXs/xVI0eqBmePk09QmlwebuqlY4VOlxdZ0TFkAo=;
        b=WM6ZsTOqhgEOadxFOHL25XONSIQi5LjQsPmfNLpRfZI3jyKfRWGnMuAu+lY2xdckDw
         l6VZNXSdWUfs2MDSmNjeBPRHScFmmfUn9gch8X3ShcaPYu0ADMb2vKtAUDkA0QVPltl9
         9p0eDLqtVyNZuNPI5Tl4cebh9jlGtCwD6xqd3gsoQwDmIi9LRQL08NyCrY6znqrJL9if
         KGBAQtutPxyt1jj0q7hWfCWnUS2clzmCy5IvYiJPIhtwockSIzPfAi4qjxSTf94D1/PY
         /bJKUnfz4TQhAK62c/c1wQtd8vcJAGZsnvxrVxfPTU6HCqQMd5K1K5fKs1xU46M7TA9Y
         0uFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk3ytQ4235GxVx6gwn4AKe53kVxT5LuT0yd1PXQeskSj2H7m1zw4bH+nmaY/wXBdzMfZHkE+OKC/32QAyFWLPP3JxNtMY04fpd5zGNu26z3FowrSQT8oyXZYnS+bpR461lSypQ/lxh+Q==
X-Gm-Message-State: AOJu0YyivNS6ZpLkA8GJyL2yTRkWxm3Imk6utFwWXcn2OXUh0vMF2xqd
	PyhpDMO491a3RB7du3AKYxrBKpQKOOR7yD/ie0fy1b2IWWWoi4Y5IauS9Wwhq0Eq5hIlsYqWMfd
	xJY10UT9EVVBZbSwLLlula2KC1t8=
X-Google-Smtp-Source: AGHT+IGHAy/9l62EKquxsTUZGlYQXzClyADc66DY/NsV80+il46z6M+yIiFPfwdTr56EhK/InWbXZug+PcV9AN4feQI=
X-Received: by 2002:a05:6870:348d:b0:258:4dcb:7d4a with SMTP id
 586e51a60fabf-25eae7eea87mr3724874fac.16.1720599454904; Wed, 10 Jul 2024
 01:17:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709064400.869619-1-nichen@iscas.ac.cn> <0c9db292-7b13-4d95-bc5f-f96800ea91b7@redhat.com>
In-Reply-To: <0c9db292-7b13-4d95-bc5f-f96800ea91b7@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 10 Jul 2024 10:17:22 +0200
Message-ID: <CAOi1vP_7fHdhZbi-Jk_RLHbNO8htX50wWFMrHyhFKMApHMq9fw@mail.gmail.com>
Subject: Re: [PATCH] ceph: convert comma to semicolon
To: Xiubo Li <xiubli@redhat.com>
Cc: Chen Ni <nichen@iscas.ac.cn>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 9:18=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/9/24 14:44, Chen Ni wrote:
> > Replace a comma between expression statements by a semicolon.
> >
> > Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> > ---
> >   fs/ceph/dir.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 5aadc56e0cc0..18c72b305858 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -1589,7 +1589,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_de=
ntry_info *di)
> >       }
> >
> >       spin_lock(&mdsc->dentry_list_lock);
> > -     __dentry_dir_lease_touch(mdsc, di),
> > +     __dentry_dir_lease_touch(mdsc, di);
> >       spin_unlock(&mdsc->dentry_list_lock);
> >   }
> >
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Applied.

Thanks,

                Ilya

