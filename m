Return-Path: <ceph-devel+bounces-33-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 107917E0029
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 11:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0CDE281DC6
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 10:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628CD12B7E;
	Fri,  3 Nov 2023 10:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnzcmDPc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1199C13AC8
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 10:07:44 +0000 (UTC)
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281971BD
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 03:07:40 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-58706a0309dso916908eaf.1
        for <ceph-devel@vger.kernel.org>; Fri, 03 Nov 2023 03:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699006059; x=1699610859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yf/delVOYXcb2KeWvXmc+da1E/CJ2va8S01GTtVPdVw=;
        b=bnzcmDPcPwiemtkl2zPJZP4PQbDgizzNpYk4p3D97Byg20rb4ysLtWjbti7kJVEGUd
         uT+wATFi1R0lqzxPkGvyUmdLT5qGDpFDjZVEtiXA+RMFtI8rFsKC1dgvf4LdMG9sRhL/
         fsRmvLpXGcrur56ETeNAVdkdydQv9b88IqShuxIUCqYGVJzYTERb+GjIktvX0GsTC1Yv
         kohrdtOeiv7DP7BGmoVBVFOJypitDqwWIKCd6kEbsWJC/pbXTYzgctCB1gEiQHKEffNw
         sI/2O2eFhQ9uAtPh9IX7L9Mt3ZX9WtITbs0/UiC0W6aJDLKG3qNGvWq8ohN+Wm7D/XTx
         /BSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699006059; x=1699610859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yf/delVOYXcb2KeWvXmc+da1E/CJ2va8S01GTtVPdVw=;
        b=rI9vGHWQpcrlkT+zeLmgYKZpRgSKs4y9ofb1U7CICDsL+lVx7F+bANp15tHEYzU8FO
         Ap//QPu02o0/9a1L0gzCyXa5eB2VgMv4IGCUgDYNji3c/QPOTXL+fL1SoS4aR+LV0AwT
         pgHfZnAjlcJl0k/8T0KOaGztN90pK8cOEGMaSqvPNWJB0pBg5mcIuNLG3PWh6B/CSA0f
         OOymWO0HvqXQjgcsTMw8DdBiDwOcoHwgIBoZIH2RQf95EMFRz3A8qXoaDGbLnPp+ddJI
         Lf25P/HN/0fQpKxIlRLcjQ2WINHXUw0jLX8GG+ZzQs3f177bQhm8+DrOpR0MN0qr7F9R
         c4EQ==
X-Gm-Message-State: AOJu0YxMT4roWNPEGDARurWbglKUKuQlrK9d5zeUJBdeR+ytZ4eGU4fz
	1518kVvWkptNCtoxDeuMzHYBi3kU/ouCSS0Bs5g=
X-Google-Smtp-Source: AGHT+IGmpks/Lai9vYIosDBs2hLw/7DPRsdbSAl0K13CNZwZfw7FK+E8/cqQWmjV6Sl+9gSEwi5u12ykWk/n3QuIzvg=
X-Received: by 2002:a4a:c919:0:b0:584:bb9:4945 with SMTP id
 v25-20020a4ac919000000b005840bb94945mr20232839ooq.3.1699006059428; Fri, 03
 Nov 2023 03:07:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103033900.122990-1-xiubli@redhat.com>
In-Reply-To: <20231103033900.122990-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 3 Nov 2023 11:07:27 +0100
Message-ID: <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 4:41=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is no any limit for the extent array size and it's possible
> that when reading with a large size contents. Else the messager
> will fail by reseting the connection and keeps resending the inflight
> IOs.
>
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/osd_client.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 7af35106acaf..177a1d92c517 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_s=
parse_read *sr)
>  }
>  #endif
>
> -#define MAX_EXTENTS 4096
> -
>  static int osd_sparse_read(struct ceph_connection *con,
>                            struct ceph_msg_data_cursor *cursor,
>                            char **pbuf)
> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connection =
*con,
>
>                 if (count > 0) {
>                         if (!sr->sr_extent || count > sr->sr_ext_len) {
> -                               /*
> -                                * Apply a hard cap to the number of exte=
nts.
> -                                * If we have more, assume something is w=
rong.
> -                                */
> -                               if (count > MAX_EXTENTS) {
> -                                       dout("%s: OSD returned 0x%x exten=
ts in a single reply!\n",
> -                                            __func__, count);
> -                                       return -EREMOTEIO;
> -                               }
> -
>                                 /* no extent array provided, or too short=
 */
>                                 kfree(sr->sr_extent);
>                                 sr->sr_extent =3D kmalloc_array(count,
> --
> 2.39.1
>

Hi Xiubo,

As noted in the tracker ticket, there are many "sanity" limits like
that in the messenger and other parts of the kernel client.  First,
let's change that dout to pr_warn_ratelimited so that it's immediately
clear what is going on.  Then, if the limit actually gets hit, let's
dig into why and see if it can be increased rather than just removed.

Thanks,

                Ilya

