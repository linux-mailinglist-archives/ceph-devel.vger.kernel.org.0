Return-Path: <ceph-devel+bounces-3554-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15958B48891
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 11:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 990BE18967FC
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 09:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA4221C186;
	Mon,  8 Sep 2025 09:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1EayQX1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670828371;
	Mon,  8 Sep 2025 09:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323968; cv=none; b=uUg/3KykRLe58QoUbgqsXYBGLtoLkBiCB3PeECMrA2MHYJpERC9ZhT+EuRegTJJk61NV1PDzamk2YSElfrxtQlfsdy7VZ9zn8zvvtaNbxUgIPtfcZzxpSKzyEOMp6/R6W3i5GLNcxXSIYPXRZMYWD/cru9NbWI7y5bn6pMcFJj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323968; c=relaxed/simple;
	bh=+Pz7YkO46IdueWY2ZlJ9XrXqxlWSnyPj4XKKpBVqIf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fdoyFVyzMrZgHCDiCp409bW2i1vuUYsY62AMJiXSakua1ovIXKsOXkuaYZ+QzVPB7NRr0G1UHD13qaMJKtvbH7vpAsc/dDZ39rfGRCOpbhTr/hV5R5URe8xq0zDJkMggkT4Ca57dGukqUqUt2fCRHEK40o1eAqbIdRxr+RwyVnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1EayQX1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-244580523a0so43190735ad.1;
        Mon, 08 Sep 2025 02:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757323966; x=1757928766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUPhDujEwhIwtnferG2DkQfBY8cKDI03hizB52EofeM=;
        b=m1EayQX1mGHq9kijDtnRd9SDnIEVO7nf/nUCnSw7deDBovBucuf401X2nKXEf48muS
         ex3mpUssCHDuzXYqFk0pPWQlnjZU7bsV8gtwImKTg0Y0pbA5Wt0Q5IseZx2l40N1QWg+
         BiwNvo03LSzEfX5aKhRMsQF7W4C0cxt0HeldnAQ7whhSl+IZyBYRTtJjZT/jWwz1QKCF
         Tu7+yf7YApExOoAaMojA78waqVFKz2yCwzsHvp4Cp09KSRmyLeWqm8Mwnea+WBF3xiiZ
         oLcABAy9PxLpCy0OTVinaVFNeCSrlfVE2+FBJsktv5tuaWL4CqRZgJw3NPZ0EShJluxT
         2isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757323966; x=1757928766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUPhDujEwhIwtnferG2DkQfBY8cKDI03hizB52EofeM=;
        b=pRVixiYYVwhn+Ye5UYzMurjK+fRN0ckjHt927b5rW6m3IKY3L4wiEepS3vtDx5yE2z
         wjSDd6JcjxcUeS4BitWys0qE/A1C95L/yRnAqYAMprFtyD2v4o8E6K9MnzOm8+z/yX+7
         iJ29JsZ+rx3v9Id3RyfL0MOAUV8sw9yj/HJkIg4bQMuDD4riT9/lDZ2d+V7RBW6VEx1r
         tukpQuLg/munn3mxsBiNn3jvxe13QJqUAZ/MIXfYj/+zDS46CAzKGInVKJtA+yE9wfUQ
         R6ngtpBBzddgCDIWxHIrLC5NolHXMbsCI/9fCwx28pmK/j/4j48SJjTv/kViydLlrZEH
         3yBA==
X-Forwarded-Encrypted: i=1; AJvYcCUOQAxY9wYKiQKfDjs3MDaFKGSgVm3ERFxee9nOa8hz9wrnKA2tDnFhnVIrAyQMsleyLLt8XMeAN3FoCorB@vger.kernel.org, AJvYcCUdvdN1Wle222EySM5DVfIq26VwFIF0u5whHF9ZyQgoSxFqa6INGNCPOFys82OxURNHlXivMHvIOEHPH8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8eHDpwdz94EJa1Vuv32cbrfarAIi7lUgsFpRnn6pfrc37x/uQ
	QY/k0XUbo5d13uDEG/9Ud5qP0IuDjP7umpMlhT2mQ33YF2spchaJ2Hi4VLmHNdJnBGE9WUb2zdK
	aLhIOAWnKxYdtEUvUzUBtn8gJz1sN/hw=
X-Gm-Gg: ASbGncvoItmerI3kzzzd2oVy80sllhF+3JIS2YUvHkVo/2hG8Aem3Q8AbTJljskFFHx
	jJAM+dt4MwAe8rt+8asvCnm7D3UPh9stTeAvf5z1JiNaV+e76sBX8tXnC5grloXtTTMgzGBIoA2
	C1WtSsPSY9z3UDL+uFbyaWyJ9zJMLiSFHefmH4oe1dQPki/W4T2A5UbNT0yzGHOon8+/C7/FV7p
	phE4GYHIpXhBs6CVw==
X-Google-Smtp-Source: AGHT+IE3dYnmkmEZ9lVXzHrTwi3LW3qAVqQrqJtINr0Ph6peALIMf/dG/dCmGmq4ODNYwmIJkGVwFcL82GHy2zRvaGM=
X-Received: by 2002:a17:903:2286:b0:24e:6362:8c97 with SMTP id
 d9443c01a7336-2516ce60405mr73974355ad.9.1757323966359; Mon, 08 Sep 2025
 02:32:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250731190227.16187-1-ebiggers@kernel.org> <CAOi1vP9QRWKoQuYHynTXuupJ=VHhLLtN3s2FE6a+gG6gvrA6SQ@mail.gmail.com>
 <20250904172558.GA854551@google.com>
In-Reply-To: <20250904172558.GA854551@google.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 8 Sep 2025 11:32:34 +0200
X-Gm-Features: Ac12FXyt88t5mUdH3bQ8VdW9m3S1OAwUoiJg0zeZiVzYQiXfTpzPJpAgykQw6xM
Message-ID: <CAOi1vP8DuaVr=A7gg54RutSgoudOjnH70n9Q4=gLukRWJ5OHiA@mail.gmail.com>
Subject: Re: [PATCH] libceph: Use HMAC-SHA256 library instead of crypto_shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 7:26=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Thu, Sep 04, 2025 at 12:24:08PM +0200, Ilya Dryomov wrote:
> > > -       if (con->v2.hmac_tfm) {
> > > -               crypto_free_shash(con->v2.hmac_tfm);
> > > -               con->v2.hmac_tfm =3D NULL;
> > > -       }
> > > +       memzero_explicit(&con->v2.hmac_key, sizeof(con->v2.hmac_key))=
;
> > > +       con->v2.hmac_key_set =3D false;
> >
> > Hi Eric,
> >
> > Since we have hmac_key_set anyway, could the call to memzero_explicit()
> > be conditioned on it?
>
> If you want.  It's less code to just do it unconditionally.

Double checking the surrounding code, the only case where hmac_key_set
would remain false is auth_none protocol (i.e. no authentication at the
Ceph level at all).  This is extremely rare, so I'm leaving the patch
as is.

Thanks,

                Ilya

