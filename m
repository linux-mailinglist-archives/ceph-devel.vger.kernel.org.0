Return-Path: <ceph-devel+bounces-2887-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A032A5F24A
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 12:26:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B767319C1D2C
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 11:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F4726618B;
	Thu, 13 Mar 2025 11:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Goipk6yy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6415926619A
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741865176; cv=none; b=lQA9sk6mUAtlREoza2qysGt3btA0gqy6xy0aJNviTWkTj8vT9YgWOD4jkcuSd9UJGqQZP4a5z67JQTbsEWFDp56jmbDHNRXYiqIMTlcgqEIdZ6MLBAEqxrIpI+dMFK5TBoJyBm6ZvpH8I/okX7PI5nZtp/tk0SCKbUrxvoK6hww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741865176; c=relaxed/simple;
	bh=j8JKeL3My3p380xaKx7CR7AkatM+RkoyVjF5AKF9V/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XROcXUtTj7585UBoq4WbxfIVOiwC6ybXRRb7Xj4amMa/BcTbksLdEi3gKfUh0WJrZ+LyDyRyccC50lRVWGjLGxMVzgFvn7wLO8XpIUhEIb1KRBeFW+yYURCc/IgAmw2pwX4hBV2mtJN8FllSixkesViub910Tt0M0hp9PFjbNr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Goipk6yy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741865173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=haq21k8jWN6ck+QB/yq8TbL/zWBVpjmfQO2fprJtAqs=;
	b=Goipk6yyCBvyiEucUCgDLtQrHtHhHffFpE32KhbNmJHjRGPLPQpMPbfPW0EGjDVbKnGO5n
	guX4SVakDVNYlN6n1fPcJbHuh72z/B7J2keW1o6pNaEziMrbaoO7Cvc02sR2hepvXt2E84
	pQGvKLB5zwSo5eqcdlX+Ymlw7QsgAzs=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-Cw1EHoB6MHa_xWdor9nVxQ-1; Thu, 13 Mar 2025 07:26:12 -0400
X-MC-Unique: Cw1EHoB6MHa_xWdor9nVxQ-1
X-Mimecast-MFC-AGG-ID: Cw1EHoB6MHa_xWdor9nVxQ_1741865171
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-86d8c567446so268744241.1
        for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 04:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741865171; x=1742469971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haq21k8jWN6ck+QB/yq8TbL/zWBVpjmfQO2fprJtAqs=;
        b=tPAPM7sNz1o7+kA0teSQ473ldGa34NUZKh9pYymk/j+5e/r1Rxibc7G5M02b2UqVCy
         JMUnoKYn0YAXP6SGFNZytkqEySUPqKavfhXdka6km8G7Dssif4BqqxWEMguAvE6j5Gwm
         U4npHVfjBuxzqPOpj6R3NEWW9bl6Z0RobKEIpg0L032cZhfeJ/eyfrXLpz8hPabAwvH5
         DEcNY51GRBg74By9ZSV51peHtArEeQ0TbAHZ82iD44wlg2HvWMJTreP2CgLPqjtGb7t0
         ln4VCL3m9Q4u4vN5y+91EqZOH49ZBXR7EXvtFnEtwcVB13VxoHXUuOiwO6FF47Z3bsah
         g2ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvnYS96VrNMzbzbXsy8rzPQpAdbM5WTlM8F8Nh8QZ2K4kSip1BCyDVSE9zTwTSdPMKChKowZLjqMSS@vger.kernel.org
X-Gm-Message-State: AOJu0YzrkaolbmK+ERw3BLpvZ1hilejUrSQ/bav1ZJLhSyaXXaR4+oAU
	PPLI8ADrJ+F4Nmt48bIVl5XnQoqOoue3WuC9iUxQKBlc6WTiahJQEb3KJ998eeTCbmjXl5Vv3UQ
	daW1gu//S7fkESElK3yzq1vjnBRnjOsnb6gARf53wuDu79RWar9y/7PUbA9AVbaHm0kDZjBVpZv
	DKpoHru2bngik9Bx7q+GPinQWpJgsoSVh0DA==
X-Gm-Gg: ASbGncu6L3mHSSZ7QL7V15X+vEaTfL2zb5ciDmbKlXqmdAHq/R9gNsoqbkKGyHEeNgF
	sxED2BD2Lnehl/7/sZrd7aY7zk4xpOUWLBqhvMBZaIYlbjs+XuJ1NIttS9wTmaLlgZVnr6x7o
X-Received: by 2002:a05:6102:8001:b0:4bb:e8c5:b149 with SMTP id ada2fe7eead31-4c30a5ab186mr20926959137.7.1741865171665;
        Thu, 13 Mar 2025 04:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5cD6PF7kl5NUY7q/OW1oKX5tNdN8eFO7rQ/PRbWr3pjIaSRJ9butzW+C+5ydIiGErfk+O9f+OrAd/60RAi1M=
X-Received: by 2002:a05:6102:8001:b0:4bb:e8c5:b149 with SMTP id
 ada2fe7eead31-4c30a5ab186mr20926938137.7.1741865171411; Thu, 13 Mar 2025
 04:26:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1243044.1741776431@warthog.procyon.org.uk> <458de992be8760c387f7a4e55a1e42a021090a02.camel@ibm.com>
 <1330415.1741856450@warthog.procyon.org.uk>
In-Reply-To: <1330415.1741856450@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 13 Mar 2025 13:26:00 +0200
X-Gm-Features: AQ5f1Jo_X07BVCwtYl8dAOwfTVb-Lg71an6NgYoZsp8YoSb8JBQQYJu-cs0jBDU
Message-ID: <CAO8a2ShNtAGnaHpf8vj_vqgkw4=020cLn8+wQ9ovOO_5zDBK7g@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix incorrect flush end position calculation
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "slava@dubeyko.com" <slava@dubeyko.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm sure @Ilya Dryomov will pick this up, this doesn't look urgent.

On Thu, Mar 13, 2025 at 11:00=E2=80=AFAM David Howells <dhowells@redhat.com=
> wrote:
>
> Shall I ask Christian to stick this in the vfs tree?  Or did you want to =
take
> it through the ceph tree?
>
> David
>


