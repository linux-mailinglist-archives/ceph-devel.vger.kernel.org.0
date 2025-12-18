Return-Path: <ceph-devel+bounces-4196-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6D7CCBED3
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 14:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D37203026B27
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 13:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB18430AAC1;
	Thu, 18 Dec 2025 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYqMQzqx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mH45WxSX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E952F83A2
	for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766063160; cv=none; b=AMKlz/ObupQlkbUzvaQ5nTgSZ9BlJNi+I4BpjtYQeuxUtoGEpZePrp21QKcScjQTfF38mAfcE4Tn5UI53G1Su8nzJnedPGREuopQHtDBfYQrZ7qMkbZBcEHNSMjNTm6z4VGfxXNn3zl1/sppRVQCdmzMb9UVj/5onKT+mlSAH9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766063160; c=relaxed/simple;
	bh=Yki4RI1niKvxDnaXXKcZA+z+TuwX/kNuqeWL3vUqdWg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rfLbQtSxRfIlJX2J6ANx0TbqghhuqmKftutldp4QkNxembpJX4wKwWvY4TF6S1ptczMCkHvHkf2rfSUzk5cxoHEL+0fP20/j6gzf7jCE1AeIJbh/oZuyq8Lp8VIRUeMDUq1srebKGrocuq4peF1AFOPL6oHbl2kDCChSTxbRws8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYqMQzqx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mH45WxSX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766063158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi8j2UszLKoE0x5JmRwZhZOTYSRg9AbqJ2V7XV2grRA=;
	b=ZYqMQzqxUvmcBJztaKNvPyaM+r00w0smNDJLQDQzhFkRpE+oAk/J9QEYNrEpj/14+86LH+
	O0F/c7KuawCxQra91510c7gc95bQzwhyGvFb4sh6dbOnwBG8uYIB/KQeVBeTndfeNJfcz/
	quVO//wbasWdSGaxjc+d+Q92sMONkQU=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-d8uAdpkIOgunb2L3k6Tfcw-1; Thu, 18 Dec 2025 08:05:56 -0500
X-MC-Unique: d8uAdpkIOgunb2L3k6Tfcw-1
X-Mimecast-MFC-AGG-ID: d8uAdpkIOgunb2L3k6Tfcw_1766063156
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-94120e0acbdso301503241.1
        for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 05:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766063156; x=1766667956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hi8j2UszLKoE0x5JmRwZhZOTYSRg9AbqJ2V7XV2grRA=;
        b=mH45WxSXXoXdoO/0udJaxhM5tHMT9L7iFd6JqLsOjB0bJ5cVAeZhgbMNwsWIAToD4c
         wJddoBVEfoVU6Ei1ayhEA089fd/wbSZY1ph2/qoK3O4J2lf1lG0lGYOvnSF6mT7gw+2o
         kpusU04SEXVk110LhYdaJLwHBYmmFYpY1WYLPuvmdXvz7odf+qCoqZB+uY3FMu3FrsI4
         /GDMMhIQkcEVs5fFbngylWBTI6Sh8AqDRbG/W0c1TPGkkGJO7AQ0svLG1qbxaZnC+ir1
         cUqGyLk8qh5K7ZNXdeDtfKGSqqL6N9wFSmmsEytOAjSMioxkzTXVLbf2blLgYk2KRPx9
         xLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766063156; x=1766667956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hi8j2UszLKoE0x5JmRwZhZOTYSRg9AbqJ2V7XV2grRA=;
        b=g76jjY7PhJUwbYwaAlzYOJOSuyEird0PLLMbL4eOWLk2a+t4lFLv71bOObhionSxh+
         Vltf6t7JZVD3OInHj2AI25mmdaLEsqNv5t3uP0YEk0muApib+COL9dZbp1DXr56aS6k5
         rXkoeCG6MCFDwIkIx8UcTWA7/P8NuYM0HPUpOJXV80nsD4cy606BNbr019YI/F7xkGRy
         wT4DfTlhyWLnKdDk80tAsmEahXR+4vBP5ZsLb+RzuB6RQVAdvr4CMCF2g1ffubxOImyb
         27Q6AHqlZYLR6SaOQ6XKfsvtKhTFcEG+0M8uv5kXz+EGQv/HmrOLGpr+rxg1lZxauuIi
         l9ww==
X-Forwarded-Encrypted: i=1; AJvYcCUueE3u7K5gL6Obheq82kZwnh+d6qrNc/n3ss3pr/O2nAB+ipnbTTxSqa8KpSXo9jyjwNUzy4RNhLH3@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0orFWXxVF6OzeBjpAmys9uXRWcSy0VphHTn7GKLRtfhm/sAhV
	g+FHq8SrjjFGjVp8l6aiOs4g0RY0mcrBfQvIvnZErPX3vFbHYe+Shv9BwyXdC5+xVQHNqwBpJu6
	t7efcezeRaZSuYM1erMRikA9A9UsF+bTw/MEE/YDFBbOFQ8Rb4SC0FajtyCgu06H+QcspS1o3j8
	vGDvCZVg9albTdoaXmTUve6WJPjATz5708RqATyQ==
X-Gm-Gg: AY/fxX6qftQUHqrg6KLvkkeL70aa+VWmPFVGppZrdXk1pUZEy/z3PE6LFKXsFEmFeIT
	Xlbh2lg4W0yKn5oCCgSagZOS2okzE1rTifDIIiwFiUjoUrIJU9UZLBVEA2PaHiH19TR0LXY3d9y
	0+1PVqa8J7ePF8Ao9tKZfxCGozDFVYSm3Y6iCPxrcao/xzWUIfGsMkhmZIDnAuyXR1GbYikJeX8
	Xj/qdLyGg==
X-Received: by 2002:a05:6102:943:b0:5dd:89c1:eb77 with SMTP id ada2fe7eead31-5e82780a607mr7205566137.29.1766063155957;
        Thu, 18 Dec 2025 05:05:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElL8beMlsB6pfz6OsFmDAy5Tzrj03M6fz87QnkOfcb+p4PFv+lkskroUYY6NSNVvKbZ5C4AtnEsPhppKz4F9Y=
X-Received: by 2002:a05:6102:943:b0:5dd:89c1:eb77 with SMTP id
 ada2fe7eead31-5e82780a607mr7205507137.29.1766063155531; Thu, 18 Dec 2025
 05:05:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216200005.16281-2-slava@dubeyko.com> <CAOi1vP88-aV+EXyVEgfiqUoSuqmaJnZ457uG6QrnOG34kimE7w@mail.gmail.com>
In-Reply-To: <CAOi1vP88-aV+EXyVEgfiqUoSuqmaJnZ457uG6QrnOG34kimE7w@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 18 Dec 2025 15:05:43 +0200
X-Gm-Features: AQt7F2okNTEuy6egWuZ050iqS2TAnEjwQleXbv20TTouiMCuELsAJ38SmDyjfN4
Message-ID: <CAO8a2Sh+C7_0+_oHDeRyUiiMZKm4cUJJ-JkNFXbihgWyFBNTyg@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: rework co-maintainers list in MAINTAINERS file
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com, 
	vdubeyko@redhat.com, Pavan.Rallabhandi@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Thu, Dec 18, 2025 at 12:37=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> =
wrote:
>
> On Tue, Dec 16, 2025 at 9:00=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko=
.com> wrote:
> >
> > From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >
> > This patch reworks the list of co-mainteainers for
> > Ceph file system in MAINTAINERS file.
> >
> > Fixes: d74d6c0e9895 ("ceph: add bug tracking system info to MAINTAINERS=
")
> > Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > cc: Alex Markuze <amarkuze@redhat.com>
> > cc: Ilya Dryomov <idryomov@gmail.com>
> > cc: Ceph Development <ceph-devel@vger.kernel.org>
> > ---
> >  MAINTAINERS | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5b11839cba9d..f17933667828 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5801,7 +5801,8 @@ F:        drivers/power/supply/cw2015_battery.c
> >
> >  CEPH COMMON CODE (LIBCEPH)
> >  M:     Ilya Dryomov <idryomov@gmail.com>
> > -M:     Xiubo Li <xiubli@redhat.com>
> > +M:     Alex Markuze <amarkuze@redhat.com>
> > +M:     Viacheslav Dubeyko <slava@dubeyko.com>
> >  L:     ceph-devel@vger.kernel.org
> >  S:     Supported
> >  W:     http://ceph.com/
> > @@ -5812,8 +5813,9 @@ F:        include/linux/crush/
> >  F:     net/ceph/
> >
> >  CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
> > -M:     Xiubo Li <xiubli@redhat.com>
> >  M:     Ilya Dryomov <idryomov@gmail.com>
> > +M:     Alex Markuze <amarkuze@redhat.com>
> > +M:     Viacheslav Dubeyko <slava@dubeyko.com>
> >  L:     ceph-devel@vger.kernel.org
> >  S:     Supported
> >  W:     http://ceph.com/
> > --
> > 2.52.0
> >
>
> Hi Alex and Xiubo,
>
> Could you please send your Acked-by?
>
> (Please ignore the Fixes tag -- commit d74d6c0e9895 isn't really
> related to this patch.)
>
> Thanks,
>
>                 Ilya
>


