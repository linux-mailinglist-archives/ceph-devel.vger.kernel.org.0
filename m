Return-Path: <ceph-devel+bounces-2515-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30270A169D0
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jan 2025 10:47:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 616D21628CD
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jan 2025 09:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA0E1AC448;
	Mon, 20 Jan 2025 09:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d2D/GsuR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D419219DF4D
	for <ceph-devel@vger.kernel.org>; Mon, 20 Jan 2025 09:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737366444; cv=none; b=u8/mv5p651HABwAQ7evEit2QTWhilthPxr+60O3tKrxwbTWpKhJBe4bsuXqpvS5t2x1d7096/kHoProo0/83h/7MAiKJCA71uY7d5XZcp6RvxRsfwxXo/XKtjcXsTCykxV1aGfMr/U5sgBIwvEkiX0nLOWSE33PrDnn9DzZijAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737366444; c=relaxed/simple;
	bh=1iVJ777YiyLvJG1svDTDIkJijD4bk6V8CR6U63bquaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0lpLKIPS0L3vkVKYEe3JfEhveP61nuPyisePBe34GeKMH4gLQFbJhDeLUq7GZek0DDSU2ZvYCZAINjh6Gwxks7r8qVoCF/4KgiTgJBRty1xYH60xECKiS2uPkccmw5Ky962sjVv2ilIVEC61KZCf/7Nx6QtAICog0RAWtytY98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d2D/GsuR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737366441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMIRS59aq0nWbPMSr4yt0OsmWKqGFD8zbWNTG+TDjbc=;
	b=d2D/GsuRyqbxjQbHG2G1xoOGFTTNwz/Kh63bKmN8gn3dA2pjA05SNFISC77GgUos5rVbqt
	E6ndiUaGI/oRKvjPLedmAWoBZJ64Exa12M0aNPuF4Nk6JFtDeY3LFpELp1JyIWf8k6CGzc
	0SYx9taLrw2tyK2h6QCAzb9tJkmdols=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-sDjLQEYOOlOPC4iuOvOgmA-1; Mon, 20 Jan 2025 04:47:19 -0500
X-MC-Unique: sDjLQEYOOlOPC4iuOvOgmA-1
X-Mimecast-MFC-AGG-ID: sDjLQEYOOlOPC4iuOvOgmA
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa66bc3b46dso348493966b.3
        for <ceph-devel@vger.kernel.org>; Mon, 20 Jan 2025 01:47:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737366438; x=1737971238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMIRS59aq0nWbPMSr4yt0OsmWKqGFD8zbWNTG+TDjbc=;
        b=bzRjbBEyDiGKwbaJF30TWlOwFY+GijVOIeqDRl6jxtJNhKVOLYRlqqbnzNXr6AJ8Nv
         nvy0xyc6rf/QCwyhIXbL/Y0Uk7MXJ0dOTfxCCwGM5P4j6hgR5rlLw1S7Ti4ANRs2ImpA
         NJXKIBjN668R/C/LiYgCmQm/FyZr56sYxnHBwo2pjhfnJ6g2Q7PshUxzNet6s7rz7Xow
         BLKlr/ksYbpF7oWDyvkyJjmXh+HjVhkDYH+e0jTmtSCeUuKzG13B41zN+aa9+O5NKLak
         esciCJ0xtxNFy0r+Qom2I7ay9cvefS/o/MOyXtBwMrUIvV0qO5OW0CWmCj9o+Gm1uD/5
         kCAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZVORh64OZa6ABwwBiFXI0GxcTnvgL8ysUJ+lWKWErgyI6Wki1YaZX2r+Un5eGHYKLCUq+jJSwVsju@vger.kernel.org
X-Gm-Message-State: AOJu0YyGQRus4w4yamIEWIylOEzUWRUEWXsBqqiJbliG6AXECMZO7FJY
	IDPmUDdULISwgS2ztQk/he0KJxsiyNBgKjCMCNZgRzXmZWM+NIPEwJWBJ/wTRGrmffRLPppuoYQ
	/b+bbRO4+szyqt+XdCXISZs9oR3XH8nb/TWheSgH7s2wNBcgyAH/UvfcgNwdnGVGlF9Q+isaq0L
	Sn6P65fvsQlnjCKW7vjFTqh5aqReRotvK8mw==
X-Gm-Gg: ASbGncuw+s5PQfzGtra8xboPDo5IGjZq0uQTYWoPl9NDw80lC4OvevgBjKF/oW/y8+x
	rPYroQBTO8uaJry1b5XkKtnAS/UuGMsBEqaPUSAyV2pzcCwNOjWs=
X-Received: by 2002:a05:6402:5246:b0:5d9:ad1:dafc with SMTP id 4fb4d7f45d1cf-5db7db073f1mr28328196a12.25.1737366438141;
        Mon, 20 Jan 2025 01:47:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8/pywkRtrHFW64kEGR6AF06UVXslrBiU03MiWk2as6N1vIWW4vX3Wyy4VobrCfoSXDwK0N33Eqa72WvKjZ7U=
X-Received: by 2002:a05:6402:5246:b0:5d9:ad1:dafc with SMTP id
 4fb4d7f45d1cf-5db7db073f1mr28328162a12.25.1737366437849; Mon, 20 Jan 2025
 01:47:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117035044.23309-1-slava@dubeyko.com> <988267.1737365634@warthog.procyon.org.uk>
In-Reply-To: <988267.1737365634@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 20 Jan 2025 11:47:06 +0200
X-Gm-Features: AbW1kvYo_PcQjA16UIVQAxxYVGTwqzpHKIw2jVbvvtE6SL51ZXZyXTdYCzS8GqM
Message-ID: <CAO8a2SgkzNQN_S=nKO5QXLG=yQ=x-AaKpFvDoCKz3B_jwBuALQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: Fix kernel crash in generic/397 test
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Easiest is to run xfstets. Ping me on slack I can show you, its simple.

On Mon, Jan 20, 2025 at 11:34=E2=80=AFAM David Howells <dhowells@redhat.com=
> wrote:
>
> Is there a way for me to test this?  I have a ceph server set up and can =
mount
> a filesystem from it.  How do a make a file content-encrypted on ceph?
>
> David
>


