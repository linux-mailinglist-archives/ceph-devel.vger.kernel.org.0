Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E8736B9D9
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Apr 2021 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbhDZTQ3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Apr 2021 15:16:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238172AbhDZTQ1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 15:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619464545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjlPen1encdZDkGM0wilUuVPtH5U8CDDV8DYPkgdQBU=;
        b=i/jhZeHGBpZUzi72TqQ6dwfZSK4OhJIYhawDDlDroEkpOdwv7ORQZQK63e7G6x7qUJXNDT
        9o2ocHbbwuu7/qPd3Lg4B/98Bw/Icip1P3Ml1XDzM4lNAqxxfFhkfa4e45J3/vAEnHFAzB
        Y24bShZNYayCCITzaE+ElgJyI/8Vx70=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-5pARX1ZdPkqZ1plYaPkIng-1; Mon, 26 Apr 2021 15:15:41 -0400
X-MC-Unique: 5pARX1ZdPkqZ1plYaPkIng-1
Received: by mail-qk1-f197.google.com with SMTP id k12-20020a05620a0b8cb02902e028cc62baso21283844qkh.17
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 12:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NjlPen1encdZDkGM0wilUuVPtH5U8CDDV8DYPkgdQBU=;
        b=F3jFtCckxK+o+Jg2FLUvx2mxr7xU2EgnEGI0+9oLpcPkeGToFhraHZj8xEI52YBP1r
         CyWfx2Kly0W2e6L0Sn8AmsrYLLY5OQctaXxXM/V1NGXpcpzRfPS4zQJ6lYs0hYFDDQFt
         Fp9dNX0YRDIuLprvFRNfTUCVgcwBDIEe91JTrpEtjPyX+QsZTfcm77d7Xz2dRijrdhh1
         EUab084SmqC0bj533sP8Tl++aBDDoKJ21NBNsrQx1tkl2/JzCbiz93qI2nl7aqaMtg23
         rbRKLD0fEdzAzAa/T1aNZ+n0p2kpsYl3UClklgtvchDzHZo+M3RvkmhVjE7MZi0ZXz2a
         PXPA==
X-Gm-Message-State: AOAM533ZIYkCvh6Dmoc08TNlbAkjbENFQcYGSHmVmHVPiZKsQiihvB8o
        QlE2nIxOQvG2WHSK4k8oKrZyYeU1LP/pozME6hEpK4f5mMOQ+sQgTBm3NgZwkx7630hfoZaua+R
        scKwqA4QqffERxvxkSUz7Zw==
X-Received: by 2002:a37:de14:: with SMTP id h20mr18965533qkj.34.1619464540670;
        Mon, 26 Apr 2021 12:15:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZYRAHl+eWnQtgdg3ck30c64eIGwlxsQ5wJdm+wrQWh9LXuumEJb2NQlXbEra5jinaPsZTlQ==
X-Received: by 2002:a37:de14:: with SMTP id h20mr18965510qkj.34.1619464540455;
        Mon, 26 Apr 2021 12:15:40 -0700 (PDT)
Received: from [192.168.1.180] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id c15sm12638215qtg.31.2021.04.26.12.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 12:15:40 -0700 (PDT)
Message-ID: <8114b7a1151edf52e3a20cf30d2673cd177191bf.camel@redhat.com>
Subject: Re: [PATCH v7 01/31] iov_iter: Add ITER_XARRAY
From:   Jeff Layton <jlayton@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Dave Wysochanski <dwysocha@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        linux-kernel@vger.kernel.org
Date:   Mon, 26 Apr 2021 15:15:39 -0400
In-Reply-To: <YIcMVCkp4xswHolw@zeniv-ca.linux.org.uk>
References: <161918446704.3145707.14418606303992174310.stgit@warthog.procyon.org.uk>
         <161918448151.3145707.11541538916600921083.stgit@warthog.procyon.org.uk>
         <YIcMVCkp4xswHolw@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-04-26 at 18:54 +0000, Al Viro wrote:
> On Fri, Apr 23, 2021 at 02:28:01PM +0100, David Howells wrote:
> > -#define iterate_all_kinds(i, n, v, I, B, K) {			\
> > +#define iterate_xarray(i, n, __v, skip, STEP) {		\
> > +	struct page *head = NULL;				\
> > +	size_t wanted = n, seg, offset;				\
> > +	loff_t start = i->xarray_start + skip;			\
> > +	pgoff_t index = start >> PAGE_SHIFT;			\
> > +	int j;							\
> > +								\
> > +	XA_STATE(xas, i->xarray, index);			\
> > +								\
> > +	rcu_read_lock();						\
> > +	xas_for_each(&xas, head, ULONG_MAX) {				\
> > +		if (xas_retry(&xas, head))				\
> > +			continue;					\
> 
> OK, now I'm really confused; what's to guarantee that restart will not have
> you hit the same entry more than once?  STEP might be e.g.
> 
> 		memcpy_to_page(v.bv_page, v.bv_offset,
> 			       (from += v.bv_len) - v.bv_len, v.bv_len)
> 
> which is clearly not idempotent - from gets incremented, after all.
> What am I missing here?
> 

Not sure I understand the issue you see. If xas_retry returns true,
we'll restart, but we won't have called STEP yet for that entry. I
don't see how we'd retry there and have an issue with idempotency.

> > +		if (WARN_ON(xa_is_value(head)))				\
> > +			break;						\
> > +		if (WARN_ON(PageHuge(head)))				\
> > +			break;						\
> > +		for (j = (head->index < index) ? index - head->index : 0; \
> > +		     j < thp_nr_pages(head); j++) {			\
> > +			__v.bv_page = head + j;				\
> > +			offset = (i->xarray_start + skip) & ~PAGE_MASK;	\
> > +			seg = PAGE_SIZE - offset;			\
> > +			__v.bv_offset = offset;				\
> > +			__v.bv_len = min(n, seg);			\
> > +			(void)(STEP);					\
> > +			n -= __v.bv_len;				\
> > +			skip += __v.bv_len;				\
> > +			if (n == 0)					\
> > +				break;					\
> > +		}							\
> > +		if (n == 0)						\
> > +			break;						\
> > +	}							\
> > +	rcu_read_unlock();					\
> > +	n = wanted - n;						\
> > +}


