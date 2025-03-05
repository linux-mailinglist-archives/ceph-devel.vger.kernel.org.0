Return-Path: <ceph-devel+bounces-2864-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13FB8A50B6D
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Mar 2025 20:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B833188DFA8
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Mar 2025 19:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097D624CEE3;
	Wed,  5 Mar 2025 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8S9h6M/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B71591E3
	for <ceph-devel@vger.kernel.org>; Wed,  5 Mar 2025 19:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741202657; cv=none; b=mDtt3gE9zMJFkRULVgioj5mzZ0olOfPlN4kDgby41vf/ammnZ7cLu/hfluKl2BpaSqZEZAg5/9ojRbnwVwkf4MaAkZ+0rl8Dn2oZHppTLJIYOCzg408HSqm/VNBsbsfpjs9naVLwVpPwW/rOnX5UIhZ5WHj2Isfenk7uwwQkXP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741202657; c=relaxed/simple;
	bh=PGeSuNkaCiXYiJReUmFpejDpVXCPlwD9a+jRtHlbTlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tjKBMPWLS8oiDq618QBT50cicNEYRLJi2YM5o/hLNG4x5FOHoYoPRXhpNBop5o0tBXCbxVqAtNk+hEm4DHqv01be9paCO+bPok8xFG75U0hSlbEhRLWAt/42fckrF0fSNrqM+HvGzINAEJzgcuO1/P/OnaKRu3y1IvXbhr+vJmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8S9h6M/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741202654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=knZE1VX+LlwYD9k4fEVN4dVQ0t7bukShujkee3U3hi4=;
	b=a8S9h6M/LN/arcEvdVjthmNuXg9urmDJ1oqWcAdxVqx9K48++1V2clZJhaYIbSl7Oe0e+4
	HRwXdx0B49Nx0dc4mAWzJybmew1NAwz4M9GiH6FmxfKuBd0migmSyTymDO6+yExIabkVfB
	mQqY6ptTFBMXOSrz7VFn1QdOUKE+moQ=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-RDhyIiYDOo-iGJRxGuYxmg-1; Wed, 05 Mar 2025 14:24:06 -0500
X-MC-Unique: RDhyIiYDOo-iGJRxGuYxmg-1
X-Mimecast-MFC-AGG-ID: RDhyIiYDOo-iGJRxGuYxmg_1741202646
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5235e5b0ad7so1500341e0c.0
        for <ceph-devel@vger.kernel.org>; Wed, 05 Mar 2025 11:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741202646; x=1741807446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=knZE1VX+LlwYD9k4fEVN4dVQ0t7bukShujkee3U3hi4=;
        b=UN2KyGNSfZxo7EwBQiGgx3qL4tVjIblrEfGoaGsCh3vqWXMToHlVJSiE0+UGtIajC4
         Ui/FthIfVjBWFtZMC32vHjuGUGW+B9op4yBUKFCEg/aNa7L1I1b0DYcglKAUqrPdKrvX
         lpZxquhm8dxgIli2SKUr3Vfje1ss8JvIRl8tM1Y2JAS5vHpaIZTsaBb/2gaOFluJWYWO
         bUM1mjTjzV+/8OBjsNA+I9aXqUWHJfJ24moKCjvSDW1lRSTyjRXQTnvSm8HLfmikxNCf
         5NrUFP1ePjUBXNv+rCkMp2/HFJglqT053U4i1pqgtbaInUDFcxMJtTINfWcOwxMCZ/CG
         9FdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZOInWrpISscefAS6NrLb1xor/RRwfMSMqyzyJ5KzSDTc4vLhde1dzJUNiCKpal6AyZB2TMlxwaQpN@vger.kernel.org
X-Gm-Message-State: AOJu0YwxIKdf4jJ1MZHVrPFaM0Xxt/FX8r6m+EyALiVY9lFriZakYHhc
	TwBYb4D+zPQTpKkN0tDPGCeGiZLsKsEICPWJdkLaHhD25r5F57aizsF79F6zMwYgFSJvfWcTP47
	I3vBaZD6zVw7Sos9tvQ8cokMGkyw1kgS1uYT3E5J23HSY9BZJwTE0nB2jRyvofCxDgyxq2rsVus
	d+2COABUf846P5IjMAUiaxH+gtI/4vPUktpw==
X-Gm-Gg: ASbGncvx9aM+LUBe72lk4s5d4VSKSzSe1YYPUbKdWaOmRGt79M1IR59tDuGCHBKnZ9P
	JGG384QDC2kbIHRIfXv8hMQsVdbWbgN4hvRVFFoNr4CJIpK3IJr9XbZtDwa0/eYpDYDa9dbzs
X-Received: by 2002:a05:6122:3a10:b0:523:8230:70db with SMTP id 71dfb90a1353d-523c62ef265mr2725086e0c.10.1741202646057;
        Wed, 05 Mar 2025 11:24:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3g32K+cbhNW7iVX+BsPrKqMNOPY4L66SSlI3W9yAkZWTctbmFOpxZr/0ZgMB7Kc1qnOuYLn53Bhz3Tc0DwAE=
X-Received: by 2002:a05:6122:3a10:b0:523:8230:70db with SMTP id
 71dfb90a1353d-523c62ef265mr2725075e0c.10.1741202645711; Wed, 05 Mar 2025
 11:24:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
In-Reply-To: <4170997.1741192445@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 5 Mar 2025 21:23:55 +0200
X-Gm-Features: AQ5f1JrxIznBL-H4czil5nVa1bIf7k0sarUmH9VATGhIapwAUaeW1UBogidw-y4
Message-ID: <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Gregory Farnum <gfarnum@redhat.com>, Venky Shankar <vshankar@redhat.com>, 
	Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That's a good point, though there is no code on the client that can
generate this error, I'm not convinced that this error can't be
received from the OSD or the MDS. I would rather some MDS experts
chime in, before taking any drastic measures.

+ Greg, Venky, Patrik

On Wed, Mar 5, 2025 at 6:34=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Hi Alex, Slava,
>
> I'm looking at making a ceph_netfs_write_iter() to handle writing to ceph
> files through netfs.  One thing I'm wondering about is the way
> ceph_write_iter() handles EOLDSNAPC.  In this case, it goes back to
> retry_snap and renegotiates the caps (amongst other things).  Firstly, do=
es it
> actually need to do this?  And, secondly, I can't seem to find anything t=
hat
> actually generates EOLDSNAPC (or anything relevant that generates ERESTAR=
T).
>
> Is it possible that we could get rid of the code that handles EOLDSNAPC?
>
> David
>


