Return-Path: <ceph-devel+bounces-51-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B327E207B
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5643AB20C84
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 11:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C709D1A5BA;
	Mon,  6 Nov 2023 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHuQ0FuB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349AB1A703
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 11:54:17 +0000 (UTC)
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE9DB
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 03:54:16 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6ce322b62aeso2790115a34.3
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 03:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699271655; x=1699876455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToZn4pMZ65C206Rb0LVW/VRnmKErBzYdcfmLdnZzPBo=;
        b=QHuQ0FuBsPEhy1Zz7OHvzqG5k/lHgcOxpzHcdckWfntf3sprH9I4VsWwVTSw4/MsLn
         rnylcGHSFGoTrkvg9bdPk0Mtg5aNkz0eHqZ9eWuFRQ50Eb3lSwQC/Fee/3HbtRHh8KZo
         6TayTUeq6F6VBez1ly02+h/kxm93oIucx8Oyy+E78CJxHsLfTEcQIijL4/IjdhJGzd+u
         FUwiRRyy3/GqG5VGriw8yDiIE0LmQL79VwEnTJEzKv5UGmDKFrpQU8TNbIPX5kGwm1eL
         mSbLXmw6kWJBplB9RY3E7tck+fhOyc8SJ2Pg8zIEij9DFCvnBM6BbEl+9W5NrWhF562j
         jyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699271655; x=1699876455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToZn4pMZ65C206Rb0LVW/VRnmKErBzYdcfmLdnZzPBo=;
        b=C/G0jJstV6KDd6aiZQa4jdDDGzENr8gQBhwMR/DDNdqxPvCbFOw26uu3tzbE/5FdHc
         siADbqfPZ/VXOw6rraabk+GyXiJHm0MqmQSkXvnBOw/xq0fjSiEN/Yb7OtT/PLOI4b1U
         p409zE9YG167lSArnz3/8MpNtPH/0Y++YNRzTHl5M/dxWdbwehIO0IbOQ3useUl4cwjV
         ehi/327PWBxL4qVfCLTcPRJ87ph4R9Ds9ewF+e5Mlw/7qjOyd//gP0LRCTKrbGFpcJZa
         Cki6xcyAFfNezbP0ToZ34NSIE/Ax49mPivabT296yz6cWR+TlKkN0jxU7UktUJwZj4wY
         Almw==
X-Gm-Message-State: AOJu0Yw1MRuaSrBM0qajkN7u2RlFr2PZaZC8OBSxBi230ntUq4pwo+6V
	rP8f9gfjqcZasPmWjMVxrFtuCXYYVcfeC1DaUOE=
X-Google-Smtp-Source: AGHT+IGAqGcjDLhco/qJp5sZf9SU1ID0ZQ1uPGhHDWtzOl/MiqPcQN41ZGqR2pyAmrkxXBY71ZSUtywufSsTdQnvsaA=
X-Received: by 2002:a9d:7982:0:b0:6ce:2c8e:79f0 with SMTP id
 h2-20020a9d7982000000b006ce2c8e79f0mr30940917otm.21.1699271655380; Mon, 06
 Nov 2023 03:54:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231106011644.248119-1-xiubli@redhat.com> <20231106011644.248119-3-xiubli@redhat.com>
In-Reply-To: <20231106011644.248119-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 6 Nov 2023 12:54:03 +0100
Message-ID: <CAOi1vP_NQmkreqVoM+CP=v3PkGh-79jYV8xgrmDA0b4z8PJ3mA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] libceph: check the data length when sparse-read finishes
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 2:19=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> For sparse reading the real length of the data should equal to the
> total length from the extent array.
>
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> ---
>  net/ceph/osd_client.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 0e629dfd55ee..050dc39065fb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5920,6 +5920,12 @@ static int osd_sparse_read(struct ceph_connection =
*con,
>                 fallthrough;
>         case CEPH_SPARSE_READ_DATA:
>                 if (sr->sr_index >=3D count) {
> +                       if (sr->sr_datalen && count) {
> +                               pr_warn_ratelimited("%s: datalen and exte=
nts mismath, %d left\n",
> +                                                   __func__, sr->sr_data=
len);
> +                               return -EREMOTEIO;

By returning EREMOTEIO here you have significantly changed the
semantics (in v2 it was just a warning) but Jeff's Reviewed-by is
retained.  Has he acked the change?

Thanks,

                Ilya

