Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2651502B3
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 09:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBCIga (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 03:36:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48846 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgBCIga (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 03:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=G2pDsW29Nx79ibmycfMTPTv+ChirvYgSU5iRViYofm4=; b=b5WCKpMM24O6CPxEP7SZ4ApZP
        aABNRwlt6K/4mqfZC/oLtj1KXFt8hGQnWg2mPkwBzppibtbBCTzdW4B1PdcTlb/Ek9hhwyVtdNK3L
        c4j+39Y25HCxGZez10pwRkIPh7UBB6Dwa7m9M4dCeY+0Wyey1mh5MNzplw86pSAB/3s9eD/pK+H3d
        eEVcUtKdDV2UTQonY9Qt8C62PfVs/01GuZR8jIQ+5U+sOZuOY/8/jhpazhoLOp798XpP8d7gsKfw2
        8Cp9OVc76gZK/7oTpkb6PL5e/qVIDDHMvijRNupyBam94Ac7/reMDR1iDqJEW/DsD7pIO+YJEt0sq
        E0DrxmmmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyXDS-0003Ni-O0; Mon, 03 Feb 2020 08:36:22 +0000
Date:   Mon, 3 Feb 2020 00:36:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 15/15] rbd: switch to blk-mq
Message-ID: <20200203083622.GA5005@infradead.org>
References: <20200131103739.136098-1-hare@suse.de>
 <20200131103739.136098-16-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131103739.136098-16-hare@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jan 31, 2020 at 11:37:39AM +0100, Hannes Reinecke wrote:
> Allocate one queue per CPU and get a performance boost from
> higher parallelism.

Well, the driver already is using blk-mq so your subject is incorrect.
I think you want to say something like "rbd: support multiple queues"
