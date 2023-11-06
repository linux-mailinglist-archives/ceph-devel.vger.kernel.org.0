Return-Path: <ceph-devel+bounces-48-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CCF7E2023
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2A41C20ABF
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 11:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C7A19443;
	Mon,  6 Nov 2023 11:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONElNeTz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A9118044
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 11:38:36 +0000 (UTC)
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DC890
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 03:38:34 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1e9a757e04eso2715915fac.0
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 03:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699270714; x=1699875514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPhJjwQjIr2G8HNl/t5H0Q25jt7/NlkKZNeH1bJnH1w=;
        b=ONElNeTz4GqWJCq9HEEBwBxEpeON12+7Ni4Z7I4k2uJ2LEDO2PBRR4BS6PANjUoHF/
         ENOw/SumxKaZNvOpNSe9mwEsk5Lpp//fbcqiqQ4oB/gmn7bzKYrSFAZzIAo9tegs7Tek
         aUmQXmXs2id803s6i2K8q1YGWEnp9gvv1+wBaSnXUd5vBiEOIE47G2PWC0bslzEVFM+A
         4CzHdSyfnNy0OOlzd05WW7MCzbOLnH0ntdeNQPgV/GurBt3x/Gmsg5L/CvjO6fmW5jAB
         eBb5TRP+vTXOOJA5KNueZFjr9vlmONQYtjEVxILr4QCiJ1tGvp4/giXzU8l0EnAtLWaR
         SOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699270714; x=1699875514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPhJjwQjIr2G8HNl/t5H0Q25jt7/NlkKZNeH1bJnH1w=;
        b=CuzvtJvvilOT4ZhkDYfP0QO+dy6kquWQ7yDrlvWgPdnP+ZwE4F24C9wLhVatlCjKzP
         B+4POX3ifxMR+pNenmnWxeyPbrq77T/qXoRuVu/W/BtJUS/BG67atsBDBHBebMOdKMAJ
         dG5gfSNsv6smVih8wFRhwd3WOtSvDnkQKVAhNn9V6aA+069J1e2hdm2sZerP0vo9wCX6
         uPzOtwgzQKvE4oYaExgtCGy/I3v1rHxaU45mOasGPBe/THMfNLClaTbLWkciTUwLIwSq
         EjhjSlG+oaYu9qVwtuz7H7XnbzYxvHrPsx2JVc3Lj67hpF/UIi9EuVbv4Ug3Hmgs4rd/
         sJQg==
X-Gm-Message-State: AOJu0Yz9mhBIdVel8Y73dB0xR9JiDLnh92LMxVyGqX1/TRWfvRDAu2QC
	aWvZ2O0Ar+Wwk7q98zlltWGd42NWNOcbwMN3fjA=
X-Google-Smtp-Source: AGHT+IE6GwpQHk3FzZXxcD5fXtamtPbdDmhCuApnMLbaoOEenqfMPlpkD8XuOfMFPF8zTK0sw2JM+TocdaekA/WnLgs=
X-Received: by 2002:a05:6870:9a87:b0:1e9:ec90:cd7 with SMTP id
 hp7-20020a0568709a8700b001e9ec900cd7mr5971013oab.10.1699270713944; Mon, 06
 Nov 2023 03:38:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103033900.122990-1-xiubli@redhat.com> <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <e350e6e7-22a2-69de-258f-70c2050dbd50@redhat.com>
In-Reply-To: <e350e6e7-22a2-69de-258f-70c2050dbd50@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 6 Nov 2023 12:38:21 +0100
Message-ID: <CAOi1vP9haOn0RujjiWU5TQ3F-ZEi8GKXYFV+xzTrX3V3saH46A@mail.gmail.com>
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 1:14=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/3/23 18:07, Ilya Dryomov wrote:
>
> On Fri, Nov 3, 2023 at 4:41=E2=80=AFAM <xiubli@redhat.com> wrote:
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
> Hi Xiubo,
>
> As noted in the tracker ticket, there are many "sanity" limits like
> that in the messenger and other parts of the kernel client.  First,
> let's change that dout to pr_warn_ratelimited so that it's immediately
> clear what is going on.
>
> Sounds good to me.
>
>  Then, if the limit actually gets hit, let's
> dig into why and see if it can be increased rather than just removed.
>
> The test result in https://tracker.ceph.com/issues/62081#note-16 is that =
I just changed the 'len' to 5000 in ceph PR https://github.com/ceph/ceph/pu=
ll/54301 to emulate a random writes to a file and then tries to read with a=
 large size:
>
> [ RUN      ] LibRadosIoPP.SparseReadExtentArrayOpPP
> extents array size : 4297
>
> For the 'extents array size' it could reach up to a very large number, th=
en what it should be ? Any idea ?

Hi Xiubo,

I don't think it can be a very large number in practice.

CephFS uses sparse reads only in the fscrypt case, right?  With
fscrypt, sub-4K writes to the object store aren't possible, right?
If the answer to both is yes, then the maximum number of extents
would be

    64M (CEPH_MSG_MAX_DATA_LEN) / 4K =3D 16384

even if the object store does tracking at byte granularity.

Thanks,

                Ilya

