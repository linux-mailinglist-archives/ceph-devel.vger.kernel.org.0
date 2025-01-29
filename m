Return-Path: <ceph-devel+bounces-2606-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC505A21E0A
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2025 14:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D2793A0FAA
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2025 13:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAE513BAE4;
	Wed, 29 Jan 2025 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OllbUtME"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862F01B415C
	for <ceph-devel@vger.kernel.org>; Wed, 29 Jan 2025 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738158138; cv=none; b=czWW1epZq70c7U4htp7mJhc/F5+welgV9HzDHJh3togHoW5jFOfesGgvhkYnBYldNFhq0m+l36Dn1XVTtu4ZFw4BAePQwIXJEg1MZnPCTRTzzFSLhEcLExhXJufJh9WARRBRKpaYpmnkq337x2aRBdPFgA4nsVP09Mo76td6D6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738158138; c=relaxed/simple;
	bh=i8T95nJXLBOq8RRYni4Dg1Qv3WQq/9E0UXSEtlhodtg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=O7lUxjHLQhSOcZFCymqje4em6waXByshu5/a06JLraaIQutpLpTzqbBUMhrBlm0eGw4c91Tgpl1XsHz60RklaEuyFtT18i9VxL25QJW3EnHR/TvQGYymJbG2qGIRIf8DzfRKLRyoYTiDmubJ2Ua/HrC1fHTDnVnTfd0kCo8lRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OllbUtME; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738158135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPZyIoL59GRKxbPwbntwWlB7zyoAQq3uGrBd57InD2I=;
	b=OllbUtMESpfADwVCQz6KbBoAkgir+1gbngxbnGr3Dd5jxMNyw0qV5kLu6CW+16Y/f9eltL
	u2gOgiNXyrbe8KyduQYK0vk8GDTspogimdseMaoRLIyNP3yBsdRH3cGmE5e4NR+XTxE0sL
	s7xuCuhPlhlrqTnz0YO05pRRMQSBDhw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-248-W3a-G6e0NtOETTLl5R4fAg-1; Wed,
 29 Jan 2025 08:42:10 -0500
X-MC-Unique: W3a-G6e0NtOETTLl5R4fAg-1
X-Mimecast-MFC-AGG-ID: W3a-G6e0NtOETTLl5R4fAg
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC9D819560B9;
	Wed, 29 Jan 2025 13:42:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.56])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F00418008DC;
	Wed, 29 Jan 2025 13:42:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAO8a2SjrDL5TqW70P3yyqv8X-B5jfQRg-eMTs9Nbntr8=Mwbog@mail.gmail.com>
References: <CAO8a2SjrDL5TqW70P3yyqv8X-B5jfQRg-eMTs9Nbntr8=Mwbog@mail.gmail.com> <d81a04646f76e0b65cd1e075ab3d410c4b9c3876.camel@ibm.com> <3469649.1738083455@warthog.procyon.org.uk> <3406497.1738080815@warthog.procyon.org.uk> <c79589542404f2b73bcdbdc03d65aed0df17d799.camel@ibm.com> <20250117035044.23309-1-slava@dubeyko.com> <988267.1737365634@warthog.procyon.org.uk> <CAO8a2SgkzNQN_S=nKO5QXLG=yQ=x-AaKpFvDoCKz3B_jwBuALQ@mail.gmail.com> <3532744.1738094469@warthog.procyon.org.uk> <3541166.1738103654@warthog.procyon.org.uk> <dbf086dc3113448cb4efaeee144ad01d39d83ea3.camel@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: dhowells@redhat.com, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
    "idryomov@gmail.com" <idryomov@gmail.com>,
    "slava@dubeyko.com" <slava@dubeyko.com>,
    "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] ceph: Fix kernel crash in generic/397 test
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3669174.1738158126.1@warthog.procyon.org.uk>
Date: Wed, 29 Jan 2025 13:42:06 +0000
Message-ID: <3669175.1738158126@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Alex Markuze <amarkuze@redhat.com> wrote:

> FYI, This the set of fscrypt of tests that keep failing, w/o this patch.
> Many of these revoke keys mid I/O.
> generic/397
> generic/421  #Test revoking an encryption key during concurrent I/O.
> generic/429. #Test revoking an encryption key during concurrent I/O.
> And additional fscrypt races
> generic/440. #Test revoking an encryption key during concurrent I/O.
> generic/580  #Testing the different keyring policies - also revokes
> keys on open files
> generic/593  #Test adding a key to a filesystem's fscrypt keyring via
> an "fscrypt-provisioning" keyring key.
> generic/595  #Test revoking an encryption key during concurrent I/O.

I presume I don't need to add a key and that these do it for themselves?

David


