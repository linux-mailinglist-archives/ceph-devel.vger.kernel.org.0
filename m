Return-Path: <ceph-devel+bounces-3030-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDAE6AB8958
	for <lists+ceph-devel@lfdr.de>; Thu, 15 May 2025 16:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C1D9A06593
	for <lists+ceph-devel@lfdr.de>; Thu, 15 May 2025 14:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB841F0E47;
	Thu, 15 May 2025 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4nsZVDU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB01EBFE0;
	Thu, 15 May 2025 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747319026; cv=none; b=XxmSUT9W3BlAqfo6c2HLZGLxFdqFlWUge/NRvpRadYEJJ9tVfZ5zFvR+od+ds0G8vgU1dqXmY2x+ftybzQ1ruE3UCf0oPuvEw86uSIy1rkpGsc56wd8ZXdkLjNDLch45BXmsvTOHPqcE/VizlybwTcgNO2lIH3Pz+2qq2d/0m6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747319026; c=relaxed/simple;
	bh=OVYj5OrIfo0hCfybiV1HY1UX5AWBWt1M6sqG61wAFTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X9iUH2D5TzoFiVyhDIBbWYDJAbd8mQcRAqQTg0QfRC7BHemay3QRnOvUxFWQT8YWLtgacHAFB8foVqtxsf8iji4MPJ5untqh0ZgESIYdFVOC0F2vnPnO7w2a6tgDpztnWhnpPbCH1FMgCFEuhSHYs40A3AvRVC6I14mFP4uuyTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4nsZVDU; arc=none smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-5fbda5a8561so1483064a12.2;
        Thu, 15 May 2025 07:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747319023; x=1747923823; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LT683tMosy0oNpKUwK8IDmqDNbDuA00iOvAYnalXVsU=;
        b=X4nsZVDUqDNSPvwzd2ZBnew7VT9vN9KECsC3P9bkM0CynS/aEyl2wRvY99DqKbo0hB
         GybvxLvYd5I0F3mzg9tnau2r9496jLRFIuoOXbArBZH4u5RaQ+8DmrLOF7D8Yl27GFBC
         W5a0+SpkwanBkoBo1DNM0S2ajPJsYoECzGJdp4rajy+ggvEEQJEZeMuwSQPr59ziw7+P
         1NXGzaYYQjmZYT25TGPh736F4nd6tp5FyyeaJ2eAOBocgP06ZD63hX3BMP58gh6cNRdd
         VV6lVadUHykEIoNOcRDJawZ1gAAQSX44Zqgcitd0OY5Xc2roPkME6g9ZXaHQeYFeu+Mn
         Z0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747319023; x=1747923823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LT683tMosy0oNpKUwK8IDmqDNbDuA00iOvAYnalXVsU=;
        b=lsoDmEVGLIUHiHyC0aQHgoKsVNxaRlwiwt5ZxBRQd1UlXtoPDbOqZedTHbN8od2K+a
         aVHkdWqjQoI+Wv5NSoMuXLHMPGJGp/ffacz4DsSwr+jIfyVC4Xe8WV4l1cNFrFxli1dJ
         f+8fEmj8iH021eZnYNSkH4kc+MWYHAUVsVPurwMm9sPIiel5Dh8GSVsehcZ3fkzUyyb6
         +qDLW3RdcHU+OnZUVXIbSzfRqkOx5ilDVh0UPfIcAURZpmb72aVcbn0PsDm0CCiKXiXR
         lxFKLxvRoBePaVzviCduBBSH/UqKBBW4NrQiuRcaQCRqwS9tmvjOa8d+GFnSegX9Oqr2
         jTOA==
X-Forwarded-Encrypted: i=1; AJvYcCUCrB7zH7uts35qnoDLeeWuy2LUXRjxrNiuNH696OGhYa02swGnaa6hpP7NqVnXIgjLjEiIub1HgOoU+hdA@vger.kernel.org, AJvYcCURfcoSyoW4pr489iz37nuN230GAazNUUXpfkN4fc10VxA0SgXj6pgi/iGYRTCdcemkGvZTMxF8hLH5ZRE=@vger.kernel.org, AJvYcCWI3Ex7j0tX/Ma3SKnkeRjnQtHNcSGn+sR7osXCSPOUcArz+D7rXkbtIZygdrN/4Re4vfMO6sm+csms@vger.kernel.org
X-Gm-Message-State: AOJu0YyIzkuwPRRC6NrdfirEhgpyZm0GudNBvc91j2ndaeC8oAkBk7dl
	P8z7L1IPljxu3tdPAGYAn/MraTG0RU5FnbIr82Vegcbezb7J7A6xWgVkFAlFRudNRIU1QBadQ+y
	o/y+1wnXL89faF3S5rr1CS6cN4fM=
X-Gm-Gg: ASbGncvKdcyRlQe33Ia1NZxgAqy77dDESh/+XxJdxUxTpynB0r/6Lf09bpfIdgzeqPf
	AwJsB8pURz2fSy7ZLcsPPmwM/rFrLtUo37w1l8vOk2KlpuaUXmx1PziMU1s6eiQGezYyIruja1r
	8qvxyWZbFLJr3E4todtn6fWtj6bgFUcuhSCyA=
X-Google-Smtp-Source: AGHT+IFyEAJq81bagI9zZEfc+JJTkgD9y2OwydxnaIK+5su8U5juDUOSuSgm09M2wmLVuHC+zB8LE0qSsQdS2C5gsxI=
X-Received: by 2002:a05:6402:1e94:b0:5ee:486:9d4b with SMTP id
 4fb4d7f45d1cf-5ff988def34mr5826953a12.34.1747319022496; Thu, 15 May 2025
 07:23:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514182015.163117-1-siddarthsgml@gmail.com> <9c69fb88-d4e1-4567-93ec-ed303b9ba01a@ieee.org>
In-Reply-To: <9c69fb88-d4e1-4567-93ec-ed303b9ba01a@ieee.org>
From: Siddarth Gundu <siddarthsgml@gmail.com>
Date: Thu, 15 May 2025 19:53:31 +0530
X-Gm-Features: AX0GCFu78zQ8IorGVkwNh6gSrwg83AW3tOwNEzVPhP1R15BtgpzFD40XhY_AJwg
Message-ID: <CAKWSiC6avoZNd+3qYMbmaT-ZM4=YpRb8N6frMA5+jbHhd4DyNA@mail.gmail.com>
Subject: Re: [PATCH] rbd: replace strcpy() with strscpy()
To: Alex Elder <elder@ieee.org>
Cc: idryomov@gmail.com, dongsheng.yang@easystack.cn, axboe@kernel.dk, 
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2025 at 12:22=E2=80=AFAM Alex Elder <elder@ieee.org> wrote:
>
> On 5/14/25 1:20 PM, Siddarth Gundu wrote:
> > strcpy() is deprecated; use strscpy() instead.
> >
> > Both the destination and source buffer are of fixed length
> > so strscpy with 2-arguments is used.
> >
> > Link: https://github.com/KSPP/linux/issues/88
> > Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
> > ---
> >   drivers/block/rbd.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index faafd7ff43d6..92b38972db1c 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -39,6 +39,7 @@
> >
> >   #include <linux/kernel.h>
> >   #include <linux/device.h>
> > +#include <linux/string.h>
> >   #include <linux/module.h>
> >   #include <linux/blk-mq.h>
> >   #include <linux/fs.h>
> > @@ -3654,7 +3655,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev=
, const char *cookie)
>
> Could the cookie argument possibly be defined with
> its size?  I.e.:
>    __rbd_lock(struct rbd_device *rbd_dev, const char cookie[32])
>
> I see all the callers pass an array that's 32 characters,
> but the function argument doesn't guarantee that.
>
> You could also abstract the cookie with a typedef and
> operations on it.

I see, I will send a v2 patch soon creating a typedef
local to rbd.c Thanks a lot for the review.

--
With Gratitude
Siddarth

