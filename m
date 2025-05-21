Return-Path: <ceph-devel+bounces-3054-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AFF8ABFD87
	for <lists+ceph-devel@lfdr.de>; Wed, 21 May 2025 21:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15DDB3B9379
	for <lists+ceph-devel@lfdr.de>; Wed, 21 May 2025 19:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1762B235067;
	Wed, 21 May 2025 19:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WyRkCKdp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com [209.85.208.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6CC1DB366;
	Wed, 21 May 2025 19:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747856840; cv=none; b=DWs2sHZAV3T4G0qCHZ3TWL+x8sbqE9628EfX+kQcJSiCeNB6MwvYIiwfZVNMb3tMXmfRSCXzRS/b3tMuSDBrse4fioUNKLBhJY71qFLNHJUyy0VIHJ1/VQE2zrULzP9eSlVexm04oMAnusdiYrS1GEOfhAJpxxqh+bzBn229O5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747856840; c=relaxed/simple;
	bh=IXLPWFUBHcmLD2QHKmTDMAIMZaxAqePVYMn1NxC6y9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DwWQv7JoDxkE2FQB+JdvlK6EjiyhBqA+9IWxRr30skrblw687TufX3x1qaiRBXasbHf3cWA8fgVqQhGk0PX1VTDve3Hxew28BLo6+SUfjknuzgRaOHhyjprDI1YPMb1Ny82FY2iFaXcLiEOf8n1wSO2mAJGCSFobU1P9p3pgAq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WyRkCKdp; arc=none smtp.client-ip=209.85.208.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f65.google.com with SMTP id 4fb4d7f45d1cf-601d10de7e1so6294990a12.1;
        Wed, 21 May 2025 12:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747856838; x=1748461638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iyCx0kbBAB2Q0O7DMG0BNAy7xo9ZkJMvOb2uCn1ttI=;
        b=WyRkCKdpQ/pjlG8hZjIK0pK8A3o4YwZOAsEuMYD4b2pwpJ2wXQSSPTfmoXJ+vpNj9w
         uuZ+CmbFKSOgNBjWMfi1XZ03DbIYm5aju4Yk1g5ygD+ml8LRLSmhuzTkA0VdOEeDeZ0I
         RID7KT0j/lSCf2zf2JBoujrOmsn5YKOspxVisAXVvcQKqt8cG5hr+rrUFDcPh9C2Fy+I
         EmSHUI0ntbbe7RaNJuzGLrECFLEEJwofpeNMassTjy8UgodACas28QMkKPRM2hO8Q/Js
         xXJ8ckcwteVUZWe7QOpOXb3WncjK6YELIU5C0yeZRkXm7Y5eGzsQb2UNG7kX880BhjDH
         p9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747856838; x=1748461638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7iyCx0kbBAB2Q0O7DMG0BNAy7xo9ZkJMvOb2uCn1ttI=;
        b=CUUd+5URH7VUcXcM586aXMb4aQK6vKenwCZRgUINzuXngtFyuTNmzPPgXJkhfEEnU/
         DI3yysX53XafgQSt9qE3T8aiFzgbAeyO256OvHuXIAMvzm9y0Y6DMEzxcdBcN9D0KA3I
         xzOhWzlRcXb5rI92D14grI7URUWRAsXIgGGXr66JCvs6H+hXnE59xamvlvl8Qikr8pz+
         5WUxIfAYqdOQkMTAeV8obxTz/uZLzi3TT+fEcULci3EBpXYbPlfTD5u6kD4Zre6+lA1q
         w7sjWquyoO/MwNVTf6P3VeeZBeVVjdgNoXGGTSCYoTy8kbwwbn/dv6EYltf9n9/lySc1
         ayUA==
X-Forwarded-Encrypted: i=1; AJvYcCVDMp8WBjFubHINQqt5vN1Lm30pkI6AQLzj+rPhLpoWcYERNeH8ekBFxWlPORGqbbUVISqyvelPClgR@vger.kernel.org, AJvYcCVPuPc3RJHYmlM7isHEfdJ7K5AkdO+USB/++vkYQiP6YqpFa4FBXOizy8zKR17IYdOG5+5cZipg5IAALFwl@vger.kernel.org, AJvYcCXZHBq2LvLtuv1ybejm1gHmVbm+BIvvSCRMvD8C+G9X1rAFQziIZDTIBH0z9iSWhQ8+ipMuVsO7tFt893U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPTVSBq3RmFizE07UPuMi7R2Lb/4hBGU8x2Zl5dJtzAQahabBv
	qZs83KPiBDof2WreNwq33fl9nYUc9qHfu4yQfj8lglmm6pEv6/Lv87wOn/dYR+ahQE8N+S4jyKu
	ca73HUm5izOkKLfuQzowhddLwBVzwISA=
X-Gm-Gg: ASbGncvp5AZlgI1K6YHu4vQXZpDixrcHSgKmg47xPG1jvRENn8zbzi+2fflCkCh5gfg
	dYmtVQrbokkrWYsEO3liTcgJGUbZHcSJBZhgcTYcBZjbz1hoDn+7/tgyjVQINdYi2Otuxrvhr9Q
	OobJfLuwgG2Y0ddaXRgPWyDRqHS8qBBTwpmg==
X-Google-Smtp-Source: AGHT+IE/MXbTsoIq1RKr3C/+xAZt/pAJymBx0EQqRqTqwdfQtXyRgjue+xX62PfeRosWSbWvzE+8Z1NZSSNOd3UkxO4=
X-Received: by 2002:a05:6402:4315:b0:602:1832:c18b with SMTP id
 4fb4d7f45d1cf-6021832d6a8mr6015506a12.24.1747856837339; Wed, 21 May 2025
 12:47:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250519063840.6743-1-siddarthsgml@gmail.com> <f92ddea4-edf1-42f9-a738-51233ce3d45e@ieee.org>
In-Reply-To: <f92ddea4-edf1-42f9-a738-51233ce3d45e@ieee.org>
From: Siddarth Gundu <siddarthsgml@gmail.com>
Date: Thu, 22 May 2025 01:17:06 +0530
X-Gm-Features: AX0GCFtg-e84KogHiSqQjcqEeiu3BsQy1wZ0rDczRtx3VSSZ8RsizuEfB-czCr0
Message-ID: <CAKWSiC5-Oqwf0TEndxbNZqCp2Z+kxq95MebDfNRNJ0fN5fWnKw@mail.gmail.com>
Subject: Re: [PATCH v2] rbd: replace strcpy() with strscpy()
To: Alex Elder <elder@ieee.org>
Cc: idryomov@gmail.com, dongsheng.yang@easystack.cn, axboe@kernel.dk, 
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 10:14=E2=80=AFPM Alex Elder <elder@ieee.org> wrote:

> I personally think the typedef here is the appropriate.  But
> it's really up to Ilya whether he likes this approach.  Get
> his input before you do more.

right, understood.

> There's a basic question about whether this is a useful
> abstraction.  It's used for "lock cookies" but do they
> serve a broader purpose?
>
> The other part of my suggestion was to define functions that
> provide an API.  For example:
>
> static inline rbd_cookie_t rbd_cookie_set(rbd_cookie_t cookie, u64 id);
> static inline u64 rbd_cookie_get(rbd_cookie_t cookie);

I see, I will try implementing such functions. Because of
using typedef I made minimal code changes.
Thanks for the detailed input

> Anyway, before I say any more let's see if Ilya even wants
> to go in this direction.  Your original proposal was OK, I
> just thought specifying the length might be safer.

Alright, I'll wait for feedback before making
any changes.

Thanks for taking time to review the patch

--
With Gratitude
Siddarth Gundu

