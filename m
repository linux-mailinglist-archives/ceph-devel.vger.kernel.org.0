Return-Path: <ceph-devel+bounces-1519-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F207392E5EA
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 13:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A97287FD0
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 11:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8622915F40A;
	Thu, 11 Jul 2024 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFOQRX18"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E39815F33A
	for <ceph-devel@vger.kernel.org>; Thu, 11 Jul 2024 11:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696174; cv=none; b=UkpvwxiUDYQNyAdbKkbzHYAp8uMBNqCw2XWZjesYj9SFfDoq7uI07SiIaf157zJpGyp+z//xTiEcGGN497g0sYFSQ9sdcPwgJLRu3A8g3dV1dRzakc+T+/xMnb+26ktG/gG04K3tjNlSdGhFqsP+sSJbclmYW2JducFuoqHIGOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696174; c=relaxed/simple;
	bh=EnAAouQ1I+az+kYULDM9b5pqBtS0JQzEK0t1K92aBJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6Joyv1uirgfE93xql3II6gC7Qd62cmMntPblep5hnaPFm5KalYbOwWJMvXr9A8PE1jgkL9vXcR+8GHt7iIYgouF2JFBK2nkp1LI8tRZJ8zo9Y2+/bTOmNLQn6G8HjV9UiRdQo0xq4Mq8FugXXZHbr9Bxar5XZNJB0NQkAtv7bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFOQRX18; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720696170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVzJw75vj91+Eg//pLvcPe8/KxMJvtRRzGShohpxMe4=;
	b=IFOQRX1882muXEaW/y8RI1N1FWuZ+aE/QayHqJ7+55MfQEuDup90Xu75LF0umhXIta1JGI
	K3/FdaPeznZwnfvuLDKnlz5xopMc+95YNzZlz0x6UWl4ORHTrhZfvMOr5fILriLDk3Lg4z
	BhnjHDZJhepZH8yQ2KZDCL/E05EPiMQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-UXTYA7nXPXKX03nC9f-MbQ-1; Thu, 11 Jul 2024 07:09:29 -0400
X-MC-Unique: UXTYA7nXPXKX03nC9f-MbQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-58bee115291so885063a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 11 Jul 2024 04:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720696167; x=1721300967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVzJw75vj91+Eg//pLvcPe8/KxMJvtRRzGShohpxMe4=;
        b=mqaGnIBT3v/HYshVBXXstIwENpdIzEkVZYh2aQ4euH7uGaDOFoG7DlhM1o0aZ7cwV3
         IynT3J2bQiFXgmSYPJgixa8S3Ta1xSWiWFsFF4NN0UkOCTcpF/IYsIGj85IBJsLK0fLN
         AOZkTZ+xum2uVztsxZ6itXWZ/J45P6yeocqMYKCcP/DV1GhfCSyq1YjSYk2hn1QgTMDL
         QhK4sOlT1xHBRo5ZV3g6QcEfO9p+R4kfoK/Kxr4KO8s/fUZn9WboT5SuNGGvNKruKBPt
         4QQMfhrf15s1Vfav7f1N8lNeG+uXaUfpru6FWr5UyIR0spKeb9lcW347ht2kSc6Q/E2G
         8yiA==
X-Gm-Message-State: AOJu0YyoUKGIJ5dc+eMNNtQoPQjc+GFus6vmQ0EqEesz7sQwcIIAVg+y
	uTD/4pf2MIyh17DHahDXS8bMJAlVUSOrDYhekL84M/uJ+khfoWyktJm38ldI1jyzp2eH4KEQGYd
	H/UF4+Qghod3CT/2jQvkZPXkMnk+k2+/O0LlhlkvpfK+AeIqzBkKYFpLCrbN6OtivbzNqMD9Lfn
	IHMI+GnY0+Kf6htVd7UiJSXb61BAk0YZ9ho8B8J4fqCw==
X-Received: by 2002:a17:906:aec5:b0:a77:c043:5b5a with SMTP id a640c23a62f3a-a780b7052e6mr450834366b.39.1720696166996;
        Thu, 11 Jul 2024 04:09:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGa/JLFLhbXlofeLtTZSSq6PTAkZnkFd+5yyWsaan2G5hzc5wHIhz1RagL6C9fibOufWnbHyiG/2VM/WU1JemE=
X-Received: by 2002:a17:906:aec5:b0:a77:c043:5b5a with SMTP id
 a640c23a62f3a-a780b7052e6mr450833666b.39.1720696166603; Thu, 11 Jul 2024
 04:09:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710122708.900897-1-xiubli@redhat.com>
In-Reply-To: <20240710122708.900897-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Thu, 11 Jul 2024 16:38:49 +0530
Message-ID: <CACPzV1kwB9JSR9_CRFGwA+e3ymYwoc6ffE1LhXBizWjiYSVSaw@mail.gmail.com>
Subject: Re: [PATCH] ceph: periodically flush the cap releases
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 5:57=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The MDS could be waiting the caps releases infinitely in some corner
> case and then reporting the caps revoke stuck warning. To fix this
> we should periodically flush the cap releases.
>
> URL: https://tracker.ceph.com/issues/57244
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c750ebcad972..b7fcaa6e28b4 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5474,6 +5474,8 @@ static void delayed_work(struct work_struct *work)
>                 }
>                 mutex_unlock(&mdsc->mutex);
>
> +               ceph_flush_cap_releases(mdsc, s);
> +
>                 mutex_lock(&s->s_mutex);
>                 if (renew_caps)
>                         send_renew_caps(mdsc, s);
> --
> 2.43.0
>

LGTM.

Reviewed-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


