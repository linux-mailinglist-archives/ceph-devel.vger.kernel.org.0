Return-Path: <ceph-devel+bounces-3055-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B80CABFD90
	for <lists+ceph-devel@lfdr.de>; Wed, 21 May 2025 21:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 844FD3B7E73
	for <lists+ceph-devel@lfdr.de>; Wed, 21 May 2025 19:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A0222F76E;
	Wed, 21 May 2025 19:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTD2A9yv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB151C8FB5;
	Wed, 21 May 2025 19:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747856978; cv=none; b=C7nV/SnHzgsaRNAJE6CI4mVBcT9UhUS9Grc/Ko5nUn8ciVxCIJBBxXyYDNhirSK41g6b6vMULJkHs/sLCeRqdSG9onbf+KFRE+nJsFRKaY0C6UFc4JIWSqcAVbONYWlcm+zTtx+OkL4Cd7pxZl/ZfEuxsdZK9I0dGKJrLPOFgRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747856978; c=relaxed/simple;
	bh=Ct3r982nkF+65bzHOr6ahGK65Ya+N5imLtfKAgktUK0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sGnvB7agGa4tVy0n7XqzfhePyovPDGW+kN3y2jLbJoL51EsRi9tvvkNUvG2AiQ9SiGg5h61TdJxBhhkGGBOpSXialEUVMu6gaVrL80+jlervgeXDx5LLlaq1bVcnNVx44bA1S/8wrWX46ig/vqP53tqtk0t91MLx9cpRs9iXJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MTD2A9yv; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-acb39c45b4eso1008485166b.1;
        Wed, 21 May 2025 12:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747856974; x=1748461774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MhYIGtg1V6i1WwhxCY/UrG0n95KnojSeWvZ4oHyL5g=;
        b=MTD2A9yvczLWF9Q5/UiCquJLv1bceKCxQKFQ3YRD/qY8X7CdMQm9lnA/vK2zXrWTkL
         BQERthNqNr49SHT/2w7rNL+j6UxgV2rMLcUgr5IiCPbLg6dRCJ9jdrr6G7mRPstj1yNT
         sW6ZYnH1OqWeBd04MBgr2tlE1Jz6hze33u25HsVe3ees1eemNAnu7Bdg9bu02+hdT/DS
         Sja8Dwd9rJJwLy8XfRhjtqMQuUOU8UWDvnbKdZiTMz64GHkCQ2ttS0lxzs07ySd5G+96
         l5jJwaZIjK5DXeFyPfo3kzcignPyvWCRxM9ztPpKV+wNvk8JoB1KULDYhsCIVWQNZAIM
         qVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747856974; x=1748461774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MhYIGtg1V6i1WwhxCY/UrG0n95KnojSeWvZ4oHyL5g=;
        b=qssS/n5qs+0i4IMAIvW4zy1f9NaaCWVSJFc/GMxIesEJHg+K0Yvvz9pMbu45eFmOnF
         bZsoxvI8YY7d0uSCuMvBswURJttmzw5bKfy7TEB9SNna7pwxjufDZfwPq5whvClhhc3W
         qusR8h1e4Acg8cb4vxzTCWOtNXSJgMFtEME4YrWf59abbsDN69ciQ5PmEeL1dbF+9BcI
         wR6eUROLaZtoWJtj8pu50jUTUbhcUEOmXKmmnxmBFU8owqHc1zHjCUUEHK3F/NAPa8Ak
         nyqcGzIcBqZkBOMgsWP91UVPpqpwHErRt0oJ3y8InuMxQ0QcDl+pYrQ2ImZs3POBn+Dg
         nfrg==
X-Forwarded-Encrypted: i=1; AJvYcCUL3UyufhCxA68+WweC0RkcpkDR2ZFKbNkXV8ZhCqbcG6WrskgDGenGw4oRKrp/+4KaJPkFHLmjyIcR@vger.kernel.org, AJvYcCVzNWrgGSybO+hryx84ngkOylRudJYjncOG3wEh83McAZnl9ZBYmj2rPYGL4050O+VmHgktuB71jvIu/FsC@vger.kernel.org, AJvYcCXAyP+ZU7pkI/5WLgwFcaG4e2xSnYrIR8gkAHWbmSkLZ0OrfKm7WZK9Js3Xhd1l9nDQP55x/fO23RgVszo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlam3PFl9P6gTdCRWaWBBSBGWZKT3Z06aEAYA0hq8ui7IH9PbL
	P2F+3gC/P4pMC0bS3MxMihKNGyze/Rk2oW5xn0Bhz6FW6+8U4vMhFSU82MuCuHUEue1jAjncc5R
	1ViRplU3cpiz12iEszeBCUb03a0Swul0=
X-Gm-Gg: ASbGnctggWhz/f8P/ld4JYa+dbN/qsKlUFsFHRTlYKN9Wm4o728F4ZrOQ4ZLYGmNUjr
	HTY7krjY5O7fFQDvjXLeLbG7e27hR/Wwxm2xx+WwUSsCKZsDYjTrm53flEwcD3DJ1RpHj0aQPWe
	SoSg3v1zdQl2peq1xf5ySy31+GKMfQM1fBbg==
X-Google-Smtp-Source: AGHT+IH3yJW4/AMtYOLM9+V77NvYogeEFHZ7bM7hybGIDFBM4bnBmb4v1qRExhMTvCE03sOBusOXjHbUo3KyjSB2PRo=
X-Received: by 2002:a17:907:728e:b0:ad5:5198:b2ad with SMTP id
 a640c23a62f3a-ad55198bc52mr1648288066b.48.1747856974188; Wed, 21 May 2025
 12:49:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250519063840.6743-1-siddarthsgml@gmail.com> <f92ddea4-edf1-42f9-a738-51233ce3d45e@ieee.org>
 <7708ccbe-f967-4910-8a73-bb66bbca214e@kernel.dk>
In-Reply-To: <7708ccbe-f967-4910-8a73-bb66bbca214e@kernel.dk>
From: Siddarth Gundu <siddarthsgml@gmail.com>
Date: Thu, 22 May 2025 01:19:22 +0530
X-Gm-Features: AX0GCFuiYwbVDi4xAkQYD5FzDul0R9twixqIk3U07Xj-6tVVKWznVORGhI1T3o8
Message-ID: <CAKWSiC6WMCsVv_=EUGFaScypXmn3yJEC5xdRN37DC9xo=VVh0A@mail.gmail.com>
Subject: Re: [PATCH v2] rbd: replace strcpy() with strscpy()
To: Jens Axboe <axboe@kernel.dk>
Cc: Alex Elder <elder@ieee.org>, idryomov@gmail.com, dongsheng.yang@easystack.cn, 
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 10:26=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 5/20/25 10:44 AM, Alex Elder wrote:
> > On 5/19/25 1:38 AM, Siddarth Gundu wrote:
> >> strcpy() is deprecated; use strscpy() instead.
> >>
> >> Both the destination and source buffer are of fixed length
> >> so strscpy with 2-arguments is used.
> >>
> >> Introduce a typedef for cookie array to improve code clarity.
> >>
> >> Link: https://github.com/KSPP/linux/issues/88
> >> Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
> >> ---
> >> changes since v1
> >> - added a typedef for cookie arrays
> >>
> >> About the typedef: I was a bit hesitant to add it since the kernel
> >> style guide is against adding new typedef but I wanted to follow
> >> the review feedback for this.
> >
> > I personally think the typedef here is the appropriate.  But
> > it's really up to Ilya whether he likes this approach.  Get
> > his input before you do more.
>
> In any case, this should be 2 patches at that point, not collapsed
> into one patch.

Understood. If the typedef approach is a go after Ilya's feedback,
I'll split the changes into two separate patches as you suggested.
Thanks a lot for the review.

--
With Gratitude
Siddarth Gundu

