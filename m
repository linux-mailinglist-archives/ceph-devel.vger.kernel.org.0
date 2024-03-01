Return-Path: <ceph-devel+bounces-945-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9861486E518
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 17:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C78FC1C2293D
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 16:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B90B70CC2;
	Fri,  1 Mar 2024 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmt/sNKF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E2071723;
	Fri,  1 Mar 2024 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709309810; cv=none; b=k8zXvptUcuJQT0RRySjU0AcZJV+4Ldh5+fNIy/vd1fMGcMSqgZ+lh8xqoYKbnfs63YV+Mg96VdOYCUBVZa5meWshfMuJ+6oQGnDeK2grrQWO0JL9csn300W3s4GPQFBAEGkKHBe3zuBhhxo+WQhka++3INDsZ+QaR9VS6g8syXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709309810; c=relaxed/simple;
	bh=Hb+XL+tFJ2+RBNB8X//YAvmc5YPkSC6Zlc0e9g8C9DQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FrMYnQ7gy+yPRK8BH9gzHodw884juPXIHNJv0FYj8/SmwDluLC7REml/+vc8j9VARLQTBtcdVDlYZkYntXv52qKElQKAHPzzv0sFEpaiIzAll5MhlcgHvIxNkAL82BBU2MEdgzEpkhzcE6wny58rAV5VdlVbvxhhWznp9mMaBk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmt/sNKF; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a0eb434eedso860252eaf.3;
        Fri, 01 Mar 2024 08:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709309805; x=1709914605; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIT/EiEf9KQAXz9XtGziKuHf6VCVJDoqEnkkL2sHVCs=;
        b=bmt/sNKFPFLpBdDlukJob/8IVmJGiunKCwFrI4dvGwfShQL1Ra+vtTupd5TIQt1Qep
         jsk+FbmPTbcG/eJT0baznY1rxap7qS9X52Hlprw5fzKv92/VqEyu8VM75G9/tQdZCnlZ
         hb60uLgHlkSBvsmIXMM5bpomSIPvDaUvmJTJZEQNTv0Aonux+bIX+OWfOToGXcJGFfMc
         YKW5M8Tbk7YPYv36VkPijsrn2g8PaPQPsAkyovhPcEqorhhp5FVu4itzcw2mB13jzJo5
         3HfN8RndxFyKutNBF0Rq9gJKRNzVlPBwl9EfgB1dXAWsvv8JI5xbH/kmarbPtObJKFdD
         v2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709309805; x=1709914605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tIT/EiEf9KQAXz9XtGziKuHf6VCVJDoqEnkkL2sHVCs=;
        b=XMOz5WyKtNcxYEjAoYRlVZkAKB3vRY02wOojuGIR6STU8M7aRuP692OUl9vlZbEu4Y
         rJl/BYo+gdUgii/4QIj8wZtmd6qoC+GDmFfRk0RrxeRU/1ml2pIsxbA0TyTmqMpIhi0y
         JX1wbSqzS7lY7u3w3dCX9coSR372L+11Kh800X3mnvj/kD5CTG7z/YJjTU0/Ut+iYcF0
         tAWBpYWAKxLUvUCtsufTfgRAvKDZRDMrxtSg80A679+lgxvWyqv1CK6qebNQSjnVnDZ8
         qCIdloviSMFNKRbRUwZkwR3kOGoUIUOhhPwGJi00BZWhzbd0S6lJBDhdpiZB2YcKMWyR
         17Tw==
X-Forwarded-Encrypted: i=1; AJvYcCVgMDdYv4Ek3iC0tQAu4lTgld+dxZGdwZbe/4Wy+mlC2V8kHKobumN3NxyQukIezqkG1nsFokZ8O4EbRa8BlRtnXg/LVdqV
X-Gm-Message-State: AOJu0YzaqJl22C1coe9Ftls6jdaIRfdAOnyRa7tycf3bvwj339xvQPUr
	G8kiG+FQkBanaHwFP2cJDdIEHC+EcdzE4QQ9HNdzoObvAeDRmmaBdxjKvRc8/Qb+0/J5d4i12pk
	MKnKmSayEELfqbEQi/vyACZzInRs=
X-Google-Smtp-Source: AGHT+IHCsUArzKeHA54s1PbcSFoE/DyijtlLoIuL+hCnX5UXeNsUYHhSBxIYEMebPVHEP72FexjB8KaCxAc78wyIlck=
X-Received: by 2002:a05:6820:41:b0:5a0:402c:f1b7 with SMTP id
 v1-20020a056820004100b005a0402cf1b7mr1802231oob.1.1709309805184; Fri, 01 Mar
 2024 08:16:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229041950.738878-1-xiubli@redhat.com>
In-Reply-To: <20240229041950.738878-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 1 Mar 2024 17:16:33 +0100
Message-ID: <CAOi1vP-hp7jmECXP4WNDT801qmBBZJjnUm0ic61Pw-JgipOyNw@mail.gmail.com>
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, stable@vger.kernel.org, 
	Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 5:22=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The osd code has remove cursor initilizing code and this will make
> the sparse read state into a infinite loop. We should initialize
> the cursor just before each sparse-read in messnger v2.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/64607
> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on=
 the socket")
> Reported-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/messenger_v2.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index a0ca5414b333..7ae0f80100f4 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_con=
nection *con)
>  static int prepare_sparse_read_data(struct ceph_connection *con)
>  {
>         struct ceph_msg *msg =3D con->in_msg;
> +       u64 len =3D con->in_msg->sparse_read_total ? : data_len(con->in_m=
sg);

Hi Xiubo,

Why is sparse_read_total being tested here?  Isn't this function
supposed to be called only for sparse reads, after the state is set to
IN_S_PREPARE_SPARSE_DATA based on a similar test:

    if (msg->sparse_read_total)
            con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA;
    else
            con->v2.in_state =3D IN_S_PREPARE_READ_DATA;

Thanks,

                Ilya

