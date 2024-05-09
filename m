Return-Path: <ceph-devel+bounces-1135-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CB78C139E
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2024 19:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 213F0282647
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2024 17:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2BDAF4EB;
	Thu,  9 May 2024 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="IpmBfoON"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140868BF0
	for <ceph-devel@vger.kernel.org>; Thu,  9 May 2024 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715274939; cv=none; b=eBUxZbSdALP8Sdpev8dyZGmKUJUnR9zAsf69vYD5uCZl6oKLOabz5LDmyUgXuxc2FOM/bDAIysmAQhuxVCQv15A7FsZ266dRXX0OkNODSZgDvhJjRoNS8jQdU2l/xeKzD158yPH8Bw5Wi27wpRM5t+Gl40sVVAHxr72ruP41qXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715274939; c=relaxed/simple;
	bh=I2b3mZDphqAOw1CzA9XXn8owOPYBXLxuDEHOZbykNDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdTUbNNMnCfmP6yzKKWaJxHVGl/Zr99KNePqNbrK1bBuvgbn235ZpGSftFMJtcXwAXkwI6p+DqHgxK/VKN+h5LsA0s6kWyLdnNVXpAyMNX1yPfTFJbfdrJu17AN9R6oOtXIhmmC8m9kT/YhKqhG2jyTE6EWP4vm+U/jbslZ62E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=IpmBfoON; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D7BD83F363
	for <ceph-devel@vger.kernel.org>; Thu,  9 May 2024 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1715274932;
	bh=R13CNUyH1MbzjMY2CalRPAAS/uvh6wjQHgeABBOaJzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=IpmBfoON8mJ+WWwGbHsP8UaUf2S5liiFXgWu3IAoBYajxKhDY/PLxu1mf7aidkXQO
	 Ri+az5lfvHD/JRuYXHLoUH9TLLCOcRLFyT4Wf+aaAu/Ze9G7GL3hQ6EKMXF0vpoQUe
	 xuKwvPuoe9kVjjP4g1IWRYW7xPJmRGxf+zq0SCAy6m9kQ02fhgQXibYNPl3fMn09I+
	 uz9x4cAO6ZyCov0dG9+kgwlqrAySwVB1d+twyXvO/Ba34KvaZ5EhXMe0B/QmhgYq2k
	 Bdl1iBLz8wlk0blPCvQoX6/26Mnqpc3hMsEyEVeRQoM3G1K3TagNm/jBhk5GhqEhEe
	 JsOoHFpRAa5WA==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a59c3cf5f83so72962266b.2
        for <ceph-devel@vger.kernel.org>; Thu, 09 May 2024 10:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715274931; x=1715879731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R13CNUyH1MbzjMY2CalRPAAS/uvh6wjQHgeABBOaJzE=;
        b=a21txFAxuPdDPlYq92xMmqbKQBWNzlnXLLt8B8kDQ+ujSG5gndmVhwGvp59jRikU5Z
         ehn3KczJsoS2bS+vEtfeTnojBKhajplr9UJ3jeNt7Q1MdZtm8gMghCw2V5RsE5Jno97Z
         xydpvaIkNC21KrzF8HFgT3U4YnuUBujdE7bJHdeNZJMLuPe3uRhThDSPv/6KeNAPbz+0
         o/FpR+NX7jHtDBSlzHBSfUdGkXHnVr/tD3VUGyMIffXAYddo3OdZbZZCIHgMZVK3T/3u
         uR5mzTvkkSt9/4MqdF/XgW7PVq4+GLPyGdPTMTf+Td9QKfuvWUW6TY+KqJBBO4t+Ktiy
         qXWA==
X-Forwarded-Encrypted: i=1; AJvYcCVBQ8HnCpQ9zNZ6HlDasZ55iN433cJVYv0yQB0WoHX/5+DlezuXQvz9INb7L/dQbI5b/79/8FRwrbVMPlG4AwVuWsQAE1J4pqpIzQ==
X-Gm-Message-State: AOJu0YzUTMLPe8TfcmN9+RzXg+9SzpkTfWcP811/XGw1xwVAApQu0d/2
	5X04+OAKLNIs1NTC5fxXG89IMt8IqOQzkNOTxdOAA1Fkr9IQiIoVqoT4jankANdMkJkBb4OpuWS
	BIeKqZnzagBk8QKDchT9zOzQPsqJEOE97cHUVsoz/kWDrdBKm4z3z9FPIKPq4QA+BtxFQ3+0ZZw
	c=
X-Received: by 2002:a17:906:3849:b0:a59:b02a:90dc with SMTP id a640c23a62f3a-a5a2d66ac03mr15004766b.54.1715274930678;
        Thu, 09 May 2024 10:15:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRId3ZK7jZnEUqxnKrbYMBDrOXsoSZ6C8TgHiChCG3zHZRXUk/mhnLLXZdmjv+NVtyVoseaw==
X-Received: by 2002:a17:906:3849:b0:a59:b02a:90dc with SMTP id a640c23a62f3a-a5a2d66ac03mr15001366b.54.1715274929765;
        Thu, 09 May 2024 10:15:29 -0700 (PDT)
Received: from localhost (host-82-49-69-7.retail.telecomitalia.it. [82.49.69.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179c81bfsm93194566b.129.2024.05.09.10.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 10:15:29 -0700 (PDT)
Date: Thu, 9 May 2024 19:15:27 +0200
From: Andrea Righi <andrea.righi@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Christian Brauner <christian@brauner.io>, linux-cachefs@redhat.com,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: Re: [PATCH v5 40/40] 9p: Use netfslib read/write_iter
Message-ID: <Zj0ErxVBE3DYT2Ea@gpd>
References: <20231221132400.1601991-1-dhowells@redhat.com>
 <20231221132400.1601991-41-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231221132400.1601991-41-dhowells@redhat.com>

On Thu, Dec 21, 2023 at 01:23:35PM +0000, David Howells wrote:
> Use netfslib's read and write iteration helpers, allowing netfslib to take
> over the management of the page cache for 9p files and to manage local disk
> caching.  In particular, this eliminates write_begin, write_end, writepage
> and all mentions of struct page and struct folio from 9p.
> 
> Note that netfslib now offers the possibility of write-through caching if
> that is desirable for 9p: just set the NETFS_ICTX_WRITETHROUGH flag in
> v9inode->netfs.flags in v9fs_set_netfs_context().
> 
> Note also this is untested as I can't get ganesha.nfsd to correctly parse
> the config to turn on 9p support.

It looks like this patch has introduced a regression with autopkgtest,
see: https://bugs.launchpad.net/bugs/2056461

I haven't looked at the details yet, I just did some bisecting and
apparently reverting this one seems to fix the problem.

Let me know if you want me to test something in particular or if you
already have a potential fix. Otherwise I'll take a look.

Thanks,
-Andrea

