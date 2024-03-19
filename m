Return-Path: <ceph-devel+bounces-984-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5063087FEEF
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 14:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8997B22FA6
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 13:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FD28061F;
	Tue, 19 Mar 2024 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mseA4T9J"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256328062E
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 13:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710855354; cv=none; b=pX2kjkmf1ioviKd0UbzMS7qyndY0AVlenNrCshrQZtcFH+x6zq9ltPHFQyTa+INBPCsDeCC6UucNKcm8F+e8nwCn8YAUYN3lYn1RoBjV96AQGhKvxDU+NR+F4nthoJYN55E3bDQ2gOZrwi22ZERdeqAQYfOOo99VMDcPnIQR6xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710855354; c=relaxed/simple;
	bh=s+Dx460IHZ8eYNhkQ7CibwGHRVkiC9dJpvRrmgIVz4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S9QqiJRmk5aC0NeBZQeAM2blf6SivDNqo45Ux2agjQK7YNZBDxedMbRZGU1aVI9JgCYmdcZmy5BII7SVf2uM8hdUy30WboopTnLEZeovVv7G5/iUH0z1q2C6Ul2zvn/5CF9v/6x6Q3KHOreF90VPwZm7qKI9z8rnkfCTdOY+LwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mseA4T9J; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c1a2f7e1d2so3584185b6e.1
        for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 06:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710855352; x=1711460152; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cosl3kf7wvccd1O0cS0Y+OnoOyr7DQWY4iYmQrZutYA=;
        b=mseA4T9J8cbxDalWYhRYktQXujfXbYkUrDOfzZF2bdHXNl75zqiofv6BiCEIB28JVZ
         u9mJHOLxhrsfMT4MT14Gq3xqGAddFv6lO+rGPgKd1ytjrR/3gYc9myfO+dZ0QduzLyYy
         cqZsXcd1jZkd1S6+7wuf09Jyc0im0VfMsO2hbfF3afmeVH/gdjGS92uhYISU0JBG0LVX
         tEJoNcJeuyYLZYleWPQp+N/Bl9d2E0SEYXMKDVsOegu72neP7Jp4qzc7dBdJIb2yAEFU
         POGY79kNObykAHl5JpWS+1k+Cc5ZwUFbHrulWLRDzf7JBLsVaBaplsXsGSDf1HhBmAyS
         /n/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710855352; x=1711460152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cosl3kf7wvccd1O0cS0Y+OnoOyr7DQWY4iYmQrZutYA=;
        b=nCIUrwnDPp21gtSRREE4snxZhNQepyrvSRvi0aYNp9GI4qlSTRL59b4/UFKpJ9u0Kv
         bf63Rt/l8uB6Iw3kh4G3hTGTeBgXwP0AxC+3MlCeGNfYX1mn42Wqo3sA7S+1kwoC/NOc
         ZtWdtKtpqHaRb8UUAj2mqqto8AQYG+xLdgXvS6XLSYV/zy3w7VZ5Gy2uq+Oj7nAeAlX0
         YqwHSxIGQnj7VK4t+fa9+GxFxAiajLBnrp2oF9D+j3CmMgD0c6hNHLz95uPVDpgdPYHC
         t8RolJ68leK+rdgHV1Sx6E1F5vcJ7aiAhWMZicU5jh2TTrX3e866AKc+mdumqEx7fVSM
         Ajkg==
X-Gm-Message-State: AOJu0YyK6wDH48DiHzD9eEs8V1+Zw22RSGzX8twpdDbHXLacZbZ5i/om
	wBn1U8C8sKqZF+CXK7K0NPBpAGXmOTq6SyKRlJCKkJOaxoRk2vBmF6Przu4zutn6TvjsaDQjyEp
	RVU0HQ9ujgd0R0ErSPAMp7CZtDreoKcR6u1c=
X-Google-Smtp-Source: AGHT+IH+XJCljV4a/fBvcIGJSSmQF2rLjWB7pkYrxHRcirawGayjHPwgOJ8kfjt/8Ynhn4nCxrTSbovfXJQ1qXgBkG8=
X-Received: by 2002:a05:6808:2087:b0:3c3:6dc5:c1a1 with SMTP id
 s7-20020a056808208700b003c36dc5c1a1mr18229245oiw.41.1710855351958; Tue, 19
 Mar 2024 06:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319002925.1228063-1-xiubli@redhat.com> <20240319002925.1228063-3-xiubli@redhat.com>
In-Reply-To: <20240319002925.1228063-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 19 Mar 2024 14:35:40 +0100
Message-ID: <CAOi1vP_xiO-0EFq2T100Tx30ayR4dyegxJR-CcZX34peYg09gg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ceph: set the correct mask for getattr reqeust for read
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, frankhsiao@qnap.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 1:32=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> In case of hitting the file EOF the ceph_read_iter() needs to
> retrieve the file size from MDS, and the Fr caps is not a neccessary.
>
> URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=3D81932=
3
> Reported-by: Frank Hsiao =E8=95=AD=E6=B3=95=E5=AE=A3 <frankhsiao@qnap.com=
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Tested-by: Frank Hsiao =E8=95=AD=E6=B3=95=E5=AE=A3 <frankhsiao@qnap.com>
> ---
>  fs/ceph/file.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index c35878427985..a85f95c941fc 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2191,14 +2191,16 @@ static ssize_t ceph_read_iter(struct kiocb *iocb,=
 struct iov_iter *to)
>                 int statret;
>                 struct page *page =3D NULL;
>                 loff_t i_size;
> +               int mask =3D CEPH_STAT_CAP_SIZE;
>                 if (retry_op =3D=3D READ_INLINE) {
>                         page =3D __page_cache_alloc(GFP_KERNEL);
>                         if (!page)
>                                 return -ENOMEM;
>                 }
>
> -               statret =3D __ceph_do_getattr(inode, page,
> -                                           CEPH_STAT_CAP_INLINE_DATA, !!=
page);
> +               if (retry_op =3D=3D READ_INLINE)
> +                       mask =3D CEPH_STAT_CAP_INLINE_DATA;

Hi Xiubo,

This introduces an additional retry_op =3D=3D READ_INLINE branch right
below an existing one.  Should this be:

    int mask =3D CEPH_STAT_CAP_SIZE;
    if (retry_op =3D=3D READ_INLINE) {
            page =3D __page_cache_alloc(GFP_KERNEL);
            if (!page)
                    return -ENOMEM;

            mask =3D CEPH_STAT_CAP_INLINE_DATA;
    }

Thanks,

                Ilya

