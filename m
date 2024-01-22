Return-Path: <ceph-devel+bounces-631-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 329B383752C
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 22:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEBC8287ECE
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 21:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C69347F66;
	Mon, 22 Jan 2024 21:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SU2BsSMx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51A047F51
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705958791; cv=none; b=EGTa2e+IXkAE7xr1phijGHG8K7Gq92NMO2QSBt9NDN44G6SIedPgVJl3zTFoo/jlebZcqvs1K89tnP0iVoZWT0JpgEXvpIjfVeV7npSvc5tx0wcyx9rWo6BNHqnZOmFgh5EevB9HjgfHMLlLvNpSwP7KD8YDN0MOXGQi+Lt0tgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705958791; c=relaxed/simple;
	bh=8F/gmFJOs+ANtRrvHV2o0M8ebCD9iXigl0W0/+sLPtg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F7UB81FokQZBOX08Ny8Ehr0hcj+ljuiCrW2VoWRzGxmYEQZHn6cM+Zev7qmGo45FzlZGkkDbUEO3O1Ai69UNN0012ZzUZTiIDYqaDDaNXGYrjIxN6jhyDACkI4jyBexiSYT9YNaA6nWUQVwlm4QNAz6TGRHnKYjTIQrEkyt7F4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SU2BsSMx; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2144ce7ff41so655888fac.3
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 13:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705958788; x=1706563588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPTpmOJpx3TmGG8VvlWgkEA63e+dhH1BebxbEFwWFOk=;
        b=SU2BsSMxksg5p+JbnxBWGQm0kTeCuUvciXPWdIs4l7/cEm+caWduvzL/9xlgjxgQKh
         Q1YYT7uR4oXXd0vnDHM7Zw+z7Nl/7QsnuGTeFgDsDteowJKfxYyUcHdGHFBHIQjODrGL
         6a2IEer2QML32xxgkLncan/Prwmupxnlft41MARpjbLmxwOrAHVOQNhwEUtzqNSCAI+b
         K1ZPWn5pNQH2h9QWVg20dFUiXmJfBi3i8wYkW1ds8qmeqQomfMBpvkVWJEcFhBd0q7nY
         h1276jNnADNixi5ilTtW/BeHPwetOLMm/+DmBxDV72fAO1WzVhaQuSmnzp2f4QUHpz7m
         lUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705958788; x=1706563588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPTpmOJpx3TmGG8VvlWgkEA63e+dhH1BebxbEFwWFOk=;
        b=PYEqlbfbTaAmH8J1pm1OwC2bwdFoKOg+oEAbHEeaZUA86f5PFwhFTdyCIIsCZHmOIn
         sioEWZ7HNZmr74T/6H97ju2EamsiP+n5MZf/y1ten/S5T74J1iQD2KSYkvjL68IBGQjc
         NMz0URtGUTW08OJ70TaeTg1brAUlDpmvp4/ycbYLUqYRYkqbYWjKofJJ3fk6f9qBxUKr
         C3gf+fq8PTXy01l8zmsmAAg6lrbdTC1XD2PjpITNuvAhxGxIqhuStJiw5XKVboMji2Pe
         GKN+oKP3/7XOfJWmIkWtN6OduKRgORPzAzvfwJRKrqADKtdpYzViB4VcLYMgFDw9Ftwf
         UMMw==
X-Gm-Message-State: AOJu0YzA8OfuvdDnFUvUZD+c+174Kf5cRTG2z6b8NyEvW3VqmIeNP+cI
	qJClyLWNE8i4kSunPWdZh6516sMGlfzb0s4+/WJrXGAdMoGVQwsDARt2yaFeJTgptV3pilhnFHP
	luH/OypbZZsuBAlIMuX8Qu3PbKq4h1N/APuI=
X-Google-Smtp-Source: AGHT+IFP+L5SkKWK8vKuvi9cF7bUzP5IOj58ForgeZHYo5CSLp8i2jShTI2wV1eI3OfRouoGeEO67s4fFDqBWIbAmMQ=
X-Received: by 2002:a05:6870:219b:b0:210:8c84:4203 with SMTP id
 l27-20020a056870219b00b002108c844203mr520157oae.103.1705958788725; Mon, 22
 Jan 2024 13:26:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215002034.205780-1-xiubli@redhat.com> <20231215002034.205780-4-xiubli@redhat.com>
 <CAOi1vP9ZOyNVC4yquNK6QUFWDr6z+M1e9M2St7uPhRkhfL7QPA@mail.gmail.com>
 <a1d6e998-f496-4408-9d76-3671ee73e054@redhat.com> <CAOi1vP8xOFA4QgMwjGyzTJuAC6T6+XDypXW3Dhhin0RnUh-ZAQ@mail.gmail.com>
 <68e4cf5a-f64f-4545-87b0-762ab920d9ba@redhat.com> <CAOi1vP_Ht9xM=k5FvXEnjAOP0kvp_rebpz+ehvmGoaOZXgMhwQ@mail.gmail.com>
In-Reply-To: <CAOi1vP_Ht9xM=k5FvXEnjAOP0kvp_rebpz+ehvmGoaOZXgMhwQ@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 22 Jan 2024 22:26:16 +0100
Message-ID: <CAOi1vP9TZ6q5GQvN6Yi+E8xFSVGErFQNS30VB-QN4fi4tL77XQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 8:13=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> w=
rote:
> I wouldn't object to cursor->sr_total_resid being added, I just don't
> like it ;)

Actually, how about just reusing cursor->sr_resid, which happens to be
an int?  Set it to -1 when con->ops->sparse_read() returns 0 and check
for that at the top:

    struct ceph_msg_data_cursor *cursor =3D &con->in_msg->cursor;
    bool do_datacrc =3D !ceph_test_opt(from_msgr(con->msgr), NOCRC);
    u32 crc =3D 0;
    int ret =3D 1;

    if (cursor->sr_resid < 0)
            return 1;

    if (do_datacrc)
            crc =3D con->in_data_crc;

    [ ... no changes ... ]

    if (do_datacrc)
            con->in_data_crc =3D crc;

    if (ret < 0)
            return ret;

    cursor->sr_resid =3D -1;
    return 1;  /* must return > 0 to indicate success */

Thanks,

                Ilya

