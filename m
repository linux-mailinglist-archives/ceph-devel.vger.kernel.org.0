Return-Path: <ceph-devel+bounces-50-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E85D07E204B
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D21C01C20B6E
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 11:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6EB1A592;
	Mon,  6 Nov 2023 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYdHAcpC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586D3199B7
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 11:46:20 +0000 (UTC)
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C6690
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 03:46:19 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-5842a94feb2so2516088eaf.0
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 03:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699271178; x=1699875978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hi1BDAKIomiPWOHgmYoVu3wTKQvKDjv2idarIBUF9t0=;
        b=MYdHAcpCgYTzo2/LqdEkE08L2mjIRtiFboVx5NPpKKINHi+78WD3IXusaW63BFzi2Y
         w/3vZ+sWXaGhXNSCrLc0cQWgxdIdZeQh1LX9PkO+44mr0rf9990l7vC2xpO/5QXE8NF0
         qon6tD/vl/zFMLZGoVblOFmbLxt4blwMBgxIR2lNaufq/b5VPtpYhDHV7NJiAIJUcBC9
         UuyxC8M78qPAx7ncZD5kaJhEH97By/M7L23VH6DmsE8KLARCf6q0Mbg7IUM2LAM3w0ST
         yzAM2p+4qSdLLLofH/z79ZSlScr30/14GHsoBfzLMDvSZFYldUluS1HezHGCNGXPxs5c
         KZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699271178; x=1699875978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hi1BDAKIomiPWOHgmYoVu3wTKQvKDjv2idarIBUF9t0=;
        b=f1JyuvbRO/HBnKpnmw5j1axk/IG9OJqsyFo3tgxqKmyZGxpMFf+OBaxhXZsWFSelDV
         YLJMPNO2Rhxuw4aiCbXvHpQfP1/foEZq+9o6kY9K/VtoeBLHsuw9UE5GRZnsr6K7f6XN
         k37J1lukbmYpM3X1qOXwN8AN3v5qmNivr2g0YVeRq8v+Z9cNir+hQNmtU3DCfqJn95gG
         gOrBD3+DWo/YncAy1VUA5H4Z+dc1RH9RemglpOaPuPpok3Tdmx59xbnSgF6LpLP4WKw5
         F0fL67K8KzPPj1FmGYrguOywJ+AhIe7fPS/9V5ibupwmTPuzPk9cTI82eIxqO5EjLfcD
         scHQ==
X-Gm-Message-State: AOJu0YxECjiszYB68exUYo/1RUoi3H+FCRE8Fwj5jjWHl19YI3WVt6gX
	YETjs7ybc6DkEWX9BvfQbTRzveQNjydMDN3TGXIheZl7BRI=
X-Google-Smtp-Source: AGHT+IG6Ar7UD2BinUcUvulI5CjqBC0wUypVlDcVTtojP0V8F6CAC7Pa6QMkRuVPLJSUNRgDfDhvEz5VumOW1LkAkjQ=
X-Received: by 2002:a4a:b487:0:b0:581:ff09:62e4 with SMTP id
 b7-20020a4ab487000000b00581ff0962e4mr26919033ooo.2.1699271178233; Mon, 06 Nov
 2023 03:46:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231106010300.247597-1-xiubli@redhat.com>
In-Reply-To: <20231106010300.247597-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 6 Nov 2023 12:46:06 +0100
Message-ID: <CAOi1vP-knSTdi5OxG=Yv5cGVJOQ7f5qhS41rhcRj-NQXhqnrtQ@mail.gmail.com>
Subject: Re: [PATCH v2] libceph: increase the max extents check for sparse read
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 2:05=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is no any limit for the extent array size and it's possible
> that we will hit 4096 limit just after a lot of random writes to
> a file and then read with a large size. In this case the messager
> will fail by reseting the connection and keeps resending the inflight
> IOs infinitely.
>
> Just increase the limit to a larger number and then warn it to
> let user know that allocating memory could fail with this.
>
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Increase the MAX_EXTENTS instead of removing it.
> - Do not return an errno when hit the limit.
>
>
>  net/ceph/osd_client.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index c03d48bd3aff..050dc39065fb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5850,7 +5850,7 @@ static inline void convert_extent_map(struct ceph_s=
parse_read *sr)
>  }
>  #endif
>
> -#define MAX_EXTENTS 4096
> +#define MAX_EXTENTS (16*1024*1024)

I don't think this is a sensible limit -- see my other reply.

Thanks,

                Ilya

