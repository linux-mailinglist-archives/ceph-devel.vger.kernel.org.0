Return-Path: <ceph-devel+bounces-35-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765647E0327
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 13:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F106AB21365
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 12:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F31168D2;
	Fri,  3 Nov 2023 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VE6snHSV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D046A1642F
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 12:50:14 +0000 (UTC)
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2931683
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 05:50:10 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b2df2fb611so1305785b6e.0
        for <ceph-devel@vger.kernel.org>; Fri, 03 Nov 2023 05:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699015809; x=1699620609; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B7y9R+quq5FLQuFPkKcVY27Yiv6JFVmYe84accfb8xo=;
        b=VE6snHSVJmordro4S7dqG3z92cyuDo4Pn/QWKxH3yd0z2UNrGN6L9YF/a698A4f83M
         5Uqw39kMdb8UL3qfnAQ2v8HmTpaSPpugDT4zVALiSEX27FSaiWTGKNih5ysKEEx/79OS
         oKx+PszUe2xjcBIj6uPMS12VuhscaB0jjAn8m0CHhAW9014olaKS0de/iAxfkyX4yD6p
         ZnsztUggUvScg8YVi1AY/luyQq1NRr66fBfawz78ESRB8okVczHnzhli/rmhHLAxJuAi
         f11Ry0VI2+cUpyMcBvl2/YJv9JcQP5Dg5suDLo+qhHzXtDXyffa5cWlzarGcJ9p1pmO1
         jPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699015809; x=1699620609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B7y9R+quq5FLQuFPkKcVY27Yiv6JFVmYe84accfb8xo=;
        b=UKhJmIUDczgfLmRnE4kx2MjlJOoar67jaHyr5ejRJYDnPjlik41t+zezWZMH4/kho7
         t+Q+7T4+TiFzRJn3N0h1k5Upu/arQVAuLxYx6+9o5s7g59zMX3SFEHHBb7YS8CkLgLKh
         YR7KYiBtB8F3IuV2IFiv7X+p4ti19uBw4jAd+E+RokBnk30Y01IFJZVU0j3wNqCc/szP
         8jU3SHO2vr/wRd1z5rnBv3kE2FtY37BP0Zw0oNNR6r/ey18ltJhfI1i14tmtxEydrAO5
         oVbdszz4PAdov/fVok7KfiFo4t6o31Pn5wgqEGyRvieIrUlHA4Ulfv3G1Zxii+q4l6CA
         GOIQ==
X-Gm-Message-State: AOJu0Yx7emaFu4h91kcO6hGycegOtYJS3WuIBFdrESSbbyHgI9xGcmpx
	dp5wzt6gMuNis2M05Wfr6ePOLrcNeWnhZMZL7Uc=
X-Google-Smtp-Source: AGHT+IEEFTTcWkwOAVLqqfg74ma4e/CImCnYBjXkL2TK0+VcZQlnchTP5LdgBRa2prCmlDZU2KsxPn6jvCBX8yTA0NM=
X-Received: by 2002:a05:6808:2102:b0:3ae:2bc8:2b93 with SMTP id
 r2-20020a056808210200b003ae2bc82b93mr29732642oiw.3.1699015809486; Fri, 03 Nov
 2023 05:50:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231101005033.21995-1-xiubli@redhat.com> <20231101005033.21995-3-xiubli@redhat.com>
In-Reply-To: <20231101005033.21995-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 3 Nov 2023 13:49:57 +0100
Message-ID: <CAOi1vP9pJGU4SeJntKoQYUarOc03Vn2sxqsd4H9LtGAe+dzZNg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libceph: check the data length when finishes
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 1:52=E2=80=AFAM <xiubli@redhat.com> wrote:
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
>  net/ceph/osd_client.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 800a2acec069..7af35106acaf 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5921,6 +5921,13 @@ static int osd_sparse_read(struct ceph_connection =
*con,
>                 fallthrough;
>         case CEPH_SPARSE_READ_DATA:
>                 if (sr->sr_index >=3D count) {
> +                       if (sr->sr_datalen && count) {
> +                               pr_warn_ratelimited("sr_datalen %d sr_ind=
ex %d count %d\n",
> +                                                   sr->sr_datalen, sr->s=
r_index,
> +                                                   count);
> +                               WARN_ON_ONCE(sr->sr_datalen);

Hi Xiubo,

I don't think we need both pr_warn_ratelimited and WARN_ON_ONCE?  This
is a state machine, so the stack trace that WARN_ON_ONCE would dump is
unlikely to be of any help.

Thanks,

                Ilya

