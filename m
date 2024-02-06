Return-Path: <ceph-devel+bounces-830-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C53484B10E
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 10:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7AD0B2528E
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 09:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CE812DD89;
	Tue,  6 Feb 2024 09:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="POyntJTu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B712D17A
	for <ceph-devel@vger.kernel.org>; Tue,  6 Feb 2024 09:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707211401; cv=none; b=mAg9FnxY3cNQWnZSbho5pCwui48i2V5wI0EErYBgLskNyUpkqHGbDK23JLknFYPW9VghuiYNOz4rXlHgAM4aB5g/nqiuLs0HP0NwRThe8CJoKfkt9IEm8LfyH7aBC0NPUqVobIkPdq99HTYtkcbJbJSaxa1sMdOz/aaKggvejMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707211401; c=relaxed/simple;
	bh=3NNqBFGIjeV1AKByKSLhrS7Ac+6gI9aohQyed1ZoEd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sI6rWxShB5q7Q1PGWkB1Z+Z3mhbRKlU+kUJQpViwPff2oXEmAs3H6FdtU9dJ072QDSfhRvnKR5weCmxQ+atIaBJ5CdA55dArOU/cgm737gH2SJc7JQwJyb7n7Zq6VoLMr/U/JWbri7hk7EN+CYnMMFw3a9n93VVZFL7pvAPlyGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=POyntJTu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707211399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02O1iwLjyGE7o3ZgJFapQf5gK7RGa7fuxMFso2F2jbg=;
	b=POyntJTuEJuKMw8UCtlgYKQfxf2+NHrBK7zVO2Gb8xQkCOKPe2C0ig2xYqal6AMBF0Vpai
	rnTjo6kw3utsE/NE/6+6TXHAllBNRwl5cpfY0VGYav9JnjBwFau2/26LYcYwBlHnJNkqAy
	9mYkkt4MLBT7BUgnNloleEgrPlCbD4g=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-H-9OxGeSMjeYnu09Pt8ZJg-1; Tue, 06 Feb 2024 04:23:17 -0500
X-MC-Unique: H-9OxGeSMjeYnu09Pt8ZJg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a3158fbb375so334644266b.3
        for <ceph-devel@vger.kernel.org>; Tue, 06 Feb 2024 01:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707211397; x=1707816197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=02O1iwLjyGE7o3ZgJFapQf5gK7RGa7fuxMFso2F2jbg=;
        b=qZ3QJzsW7Nl4Qs9Jo9qM9SjgSShqspjw/XPf7lNNDUq/u7ek+thGMQwWvJ8edxkG/O
         TwgjwJOPnTnggb8QY6y7Et4WIz9rJ6JB3N66Yok0EtPVWDqOaIeyBD3vrf3K0ObbUXoX
         i6sQg5eR09digdzf1dntwbbJDT2V+5Ru28S9C5EYcLyy35Uem2hlFg3v59C7qZamEyZ1
         SV2PjUpFA80amWwwayUGJagO8Wq425c4bgVV5tghCPZ3Y+1FgSKIdyuaQMPMQE6cH8tP
         6qHTxsiPE13dNElc9+7Fkgce5At/1P3ekgZt/CdXnYK8teUB8QmCUBNcBRS4C8sYHgYP
         0ffQ==
X-Gm-Message-State: AOJu0YyDnfLwC4f+FKBoksn6wK7feP+Jy7O9z7OkZN1qGKeVWfjlchui
	66JrbzyojAce8HEvVL33uBCsTFOJbIblgHEhFotTkhEuzZ7V/bwvrZ7RI8iF/zeFUFLSTzl7rpg
	2JwL/4iatdpBYpo/hOT8Ng95U/MR3J02EAdPYnWEBZelz4DgXZk6xRA6WxKJPlMybQrbsDWpmvp
	9Fc3mQCN28fCbEjgOEVYIPEbQEKvN2T4pdHA==
X-Received: by 2002:a17:906:2c47:b0:a38:b94:48bf with SMTP id f7-20020a1709062c4700b00a380b9448bfmr1157233ejh.0.1707211396930;
        Tue, 06 Feb 2024 01:23:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKG8CaQ4IF1cf4Jv+p1a3b5AvA5yNYD3X3Ey61RcafhQcqmT4JJ2Ul2ADTM8jsb/FHqucUgUpqGLv7o0CcxR0=
X-Received: by 2002:a17:906:2c47:b0:a38:b94:48bf with SMTP id
 f7-20020a1709062c4700b00a380b9448bfmr1157226ejh.0.1707211396677; Tue, 06 Feb
 2024 01:23:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230824095551.134118-1-xiubli@redhat.com>
In-Reply-To: <20230824095551.134118-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Tue, 6 Feb 2024 14:52:40 +0530
Message-ID: <CACPzV1=ONJL35DeXB20GEpou4xQSQ_DtbM4rC7AMjLOF+nkXpg@mail.gmail.com>
Subject: Re: [PATCH] ceph: skip reconnecting if MDS is not ready
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, pdonnell@redhat.com, idryomov@gmail.com, 
	jlayton@kernel.org, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2023 at 3:28=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When MDS closed the session the kclient will send to reconnect to
> it immediately, but if the MDS just restarted and still not ready
> yet, such as still in the up:replay state and the sessionmap journal
> logs hasn't be replayed, the MDS will close the session.
>
> And then the kclient could remove the session and later when the
> mdsmap is in RECONNECT phrase it will skip reconnecting. But the
> will wait until timeout and then evicts the kclient.
>
> Just skip sending the reconnection request until the MDS is ready.
>
> URL: https://tracker.ceph.com/issues/62489
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9aae39289b43..a9ef93411679 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5809,7 +5809,8 @@ static void mds_peer_reset(struct ceph_connection *=
con)
>
>         pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
>                        s->s_mds);
> -       if (READ_ONCE(mdsc->fsc->mount_state) !=3D CEPH_MOUNT_FENCE_IO)
> +       if (READ_ONCE(mdsc->fsc->mount_state) !=3D CEPH_MOUNT_FENCE_IO &&
> +           ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >=3D CEPH_MDS_S=
TATE_RECONNECT)
>                 send_mds_reconnect(mdsc, s);
>  }
>
> --
> 2.39.1
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


