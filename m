Return-Path: <ceph-devel+bounces-2388-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8319F6D9E
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 19:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CB2416816B
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 18:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E7B1FBC91;
	Wed, 18 Dec 2024 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QeZENIgW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411331A23A4
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734547700; cv=none; b=VyHAJbEOo9x+HmVkzCupRe6+IEw37I6FgmalgPxl8DgEWt1pZruKIHz528xB3Cx6mhIBZxiFbRBqXWeWVDJbGgzi+Pm203XCTmXJgdU4Fhkbb7bs6bZeTZrr2WLLmmfiIrjdak/NyJXEPB+MHEiH7Qdn1LcbiNTgvB5qXAIEA6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734547700; c=relaxed/simple;
	bh=Wk7EU0ytP8hY/vCIGFtE2cggHvtOIXl/UftACoCEbkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uw4lbS3VYRYyQZwzmpRtVUWiDsAdKuYRsemmqJNNAzYv942QjzYU9NAD0lx0lsrnmOMXI1tl4rPGOkGIU8H0+/Tn9/JqwBWiPKJZoMS27guMt9ltERhSSjY5nsLSTRDo5tMHAYsOmPi6lc2NxEHqNRYgnd1lucqIBKEx6BDJIdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QeZENIgW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734547697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wk7EU0ytP8hY/vCIGFtE2cggHvtOIXl/UftACoCEbkI=;
	b=QeZENIgWVNgGBrm6aYbEZsU/xhzw7avZlZTWO5nt+Qh61g3prL0q9aBJb5gJXxLMDHMoFK
	dVgU8snAOPIGvEVJYJxwOjyfRQeYIlAJxYhW+JBE+8o63JQuOsq3bTOGgqWsosf9eZw5r3
	7jx8zLRDqVf7CfOsyee2rgzd62ANzAQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-yY4dcZVkPGm2Y0HWsl2l2A-1; Wed, 18 Dec 2024 13:48:16 -0500
X-MC-Unique: yY4dcZVkPGm2Y0HWsl2l2A-1
X-Mimecast-MFC-AGG-ID: yY4dcZVkPGm2Y0HWsl2l2A
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-467b19b55d6so64575631cf.2
        for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 10:48:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734547695; x=1735152495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wk7EU0ytP8hY/vCIGFtE2cggHvtOIXl/UftACoCEbkI=;
        b=Bqkie39hOb/id7OyDaXzbDYTX9/cTGAJIX8mUlPze7wdCjo21XOp+RorcZUQCAEa2D
         3Jd22JZKHV1yBv+JX6Plb7OWy0yvDRU53secUdCUrtmhUyPzDJJ0T9LFBo3E/HIW8w1e
         GvUISiZTphw4pLuFcdCZcuXWqhG2ksy4pQWfWDVm4t3v9AZBWH+73sYZmxLB5FILc+ep
         3i2lN7xYmE7gAWvxPp3QxQA/o+FKLmMQr2kdQ6+1eUGYCj0ukfTpVUVd8XJw9qiyGfnU
         8iTXvRylpv6tsNZtfeDgFIVRK6q+HI3R4TByXlvzD10vaiMyKNJBv0b7sk15NZSDlbWo
         wHTQ==
X-Forwarded-Encrypted: i=1; AJvYcCURsR7oJ/v9GbTPAth1wk3hUIoEABdz1ZgN+jbkkjyJGWeaFkZdwcJfiS5L/FGhPbvnowPdj9mKWB+/@vger.kernel.org
X-Gm-Message-State: AOJu0YxDZWv69J41FJdCvCHzGfo+Q1HiSS7AZzEZ6YkOpuYgMgGf79w+
	kwdzUqcMbxwGMWZag9P0BZvCVYw7jzdAXIk/VMESacnzTnbf0aZHMUkNQupjj0hxcpPp8hS+BIs
	9rwVYOxH9XZSwP8PnFfCfR0m6dwVIVRATg+sjNa6nI5BXoz8U2FR7FAGePg8e2ebeaIS6b5zgXU
	fcSJAe9duoaW2r4Hbh95BJXtE6YT01EOQtfQ==
X-Gm-Gg: ASbGncukPYn3wk+/2+mzdOo/M2F0OQu7AB1XGdMv3UyTqjYZ0686ZiHMonRIoN4FoZQ
	JbZLejjFDOCutDxSMLQmZk9HLhhjEJe/MJ27+xg==
X-Received: by 2002:a05:622a:1828:b0:467:70ce:75e9 with SMTP id d75a77b69052e-46908e022d8mr64195211cf.23.1734547695701;
        Wed, 18 Dec 2024 10:48:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTVv+XdS41U4i15obok7wAWPYGesrwGIM+ruomJGBbnb0CVE9F17mMba1sCRuq3dKoJgnBmXNFkG96ND3MBeI=
X-Received: by 2002:a05:622a:1828:b0:467:70ce:75e9 with SMTP id
 d75a77b69052e-46908e022d8mr64194911cf.23.1734547695442; Wed, 18 Dec 2024
 10:48:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk>
In-Reply-To: <3989572.1734546794@warthog.procyon.org.uk>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Wed, 18 Dec 2024 13:47:49 -0500
Message-ID: <CA+2bHPbSWHEkJso18Ua=k+OccZq4HzuOLAmZYTD1d5auDxQ9Vw@mail.gmail.com>
Subject: Re: Ceph and Netfslib
To: David Howells <dhowells@redhat.com>
Cc: Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello David,

On Wed, Dec 18, 2024 at 1:33=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
> Also, that would include doing things like content encryption, since that=
 is
> generally useful in filesystems and I have plans to support it in both AF=
S and
> CIFS as well.

Would this be done with fscrypt? Can you expand on this part?

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


