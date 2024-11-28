Return-Path: <ceph-devel+bounces-2208-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 957EE9DB78F
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 13:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24BD6B236C7
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 12:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B7119D899;
	Thu, 28 Nov 2024 12:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UR9H+rPB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1D7195385
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 12:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796910; cv=none; b=RrLHHZPoOwi0EkWg4z8SktT36NUIHit0xgv4WDoJHAf66JZr1z/ROjX1iuKsPNBKP5oCp8foLOKFqG1KQE3GNdeMv8Ki/ixrHa0XuVIjWu8Ilxyx69ESEq0i3McTHeDrcUh0ibxsSMl2g11bGvKBEQ1Rb5Yxc4oV/wD7pgR9yzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796910; c=relaxed/simple;
	bh=MOT2fR8awT9bMTqFJViZ1GmaBnBHbdhxmtDeJixFVwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=srMQFXcp1oRSXabGlNM668T7x3TCth1tyjaT/UbGxPmekCMAnRWGCwimFmMq1DkrEZP8Ve0+ztb9nZiMBnZFPlsZYCWxlp9Isjsoc1mLAGPiAqDjPsmgJVk82F0w0u2lYyVEXHfiKHFQOetJ8S0c5VL5qDjaCs4AsgYiHFl+1Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UR9H+rPB; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53df63230d0so717875e87.3
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 04:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732796906; x=1733401706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOT2fR8awT9bMTqFJViZ1GmaBnBHbdhxmtDeJixFVwA=;
        b=UR9H+rPBh6ko11f0iuF0UYGbvVhOnxCUEDXWk6AbUJdZygdVCMzWHMn/cCKFy2vCiv
         P+p6qdsSBN9QQ49bS5mR1ERfrPqSNkCSYFGRY3V9EtK9/07cLo0v4W3FIxgt10SK5H5m
         fctJndO6IuOscqbXJs73egxSYMl0AtribQPg7/+pS23ZNKwhh/b6bo+dv61lnw20AbFQ
         TF2R6IsQ9AFxuf+wNUwdMafcJwC2wSI9+5zgkHQ9mAn2mA0ScKNAeOjiLCdhmVitNijl
         Q0KlwH9VKP9m4WJ4GJoL/RmT9bMiKeVTdbJOg/pMpVzeVxPeGSYwT+UzxhWkZTK32NYU
         Kk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732796906; x=1733401706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOT2fR8awT9bMTqFJViZ1GmaBnBHbdhxmtDeJixFVwA=;
        b=nO4wVUbe8u6KhvX3ulF16UtHr43dsoLa7S5J6gQxikmoLCdWq9hHGOc/Mmnq7aG8CQ
         7mhjUc3f851GfbPlESyXnZVZZU68NFTOHWtJck/KgOMwi9zk2qV5bQ7hfLher9bb+MLC
         yE+8HlkunjvhmgyenpHFAh2azsfx6tBVDsHBlLVEdOzKpZuyBNtzSyp7mFtiZG1poeL/
         YjlotNssF6YbpKymQKDu/+PnYxvHdUwomlC9vrYyp6b8ip7gA3uAnE16umqGSbFIYQXg
         HdhnVsMNkPkeX/o3CZOLhmWX3vmXi0jbwDzPsUzMImu8Q3aAcdemrUiK8Y4BAff/SVyp
         a2GQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9GizM8UbJhIWweVZHPqbwDHAQPb9x8aZYYRBk/SJ+lZTfI46wAE4qIcPcrja7PJLaylnRibtQUxm9@vger.kernel.org
X-Gm-Message-State: AOJu0YzsYjOZDYfzSmEdg6Znfckf0M3hELrkenRPkOzL2WWQYVXwmst5
	QoIzA0FbkhnG99bCAPB5KFlF1GrfZB8c1ldUQ1G3MQsWXOi0+LnVxj4rOetkH/tvpAcb/O2/PvR
	dGgOxaNeWlIzYr9dT/vOCbTBhDYc1OU0Pv6bHSg==
X-Gm-Gg: ASbGncspHPW2QVXe8Lm5vOT4xd/icEhk6fjI7uWZrODIt+BbSKgPzRO+bzclP76gXw2
	8ARoLaTbmL2l70L+cbDkQqYTieGvgolvhAcxPeb5nZFFLCS68oD09jkWLytQt
X-Google-Smtp-Source: AGHT+IEdrLtj9NaXXUfCeQxVjlSafuVoPdRfD2yexlIaCJux0eAYLUG/36jd9cMhQ1bPlx07fZHGswpMMleKK6+/fH0=
X-Received: by 2002:a05:6512:3119:b0:53d:f1cb:6266 with SMTP id
 2adb3069b0e04-53df1cb62e3mr2782497e87.28.1732796906369; Thu, 28 Nov 2024
 04:28:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com> <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
In-Reply-To: <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Nov 2024 13:28:15 +0100
Message-ID: <CAKPOu+-Xa37qO1oQQtmLbZ34-KHckMmOumpf9n4ewnHr6YyZoQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 1:18=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> Pages are freed in `ceph_osdc_put_request`, trying to release them
> this way will end badly.

I don't get it. If this ends badly, why does the other
ceph_release_page_vector() call after ceph_osdc_put_request() in that
function not end badly?

