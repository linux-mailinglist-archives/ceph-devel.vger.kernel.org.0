Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F8782DA8
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 10:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731711AbfHFIZW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 04:25:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730068AbfHFIZV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Aug 2019 04:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rUHpKHn0Tc9SregrETfddkybOV3JSLyP5uCclUMnWe4=; b=mm11TT8D4JZumuo+P5u8bFBCBt
        JhcGcctHl6quJPyAJXRDJm0JufIPwi5BaJ2MKHYcmzuWR7Ira/Su/ILT9q3dvoEpzoxMm+LOlXBGM
        65O8AFGLSVELcsRsUtYBOn8w/DOkl7ZXSx67XKkYRru0pxCb4Y9g/coPyuDxLmKyAc3JKq//UHpPc
        c9MQq/teevs/zeroAlJD+wBOye00ZEC1oxuT0FDDbs912w8jvM0m92w/rdDJfbHzsYW5pwbhKRlrb
        rM3CajAQEglRYYClDL1B2LWtybxLqNYFhgv1UOL+s8Ixz1/Nmf/FIhkPGshgujYT0R2t6V2gW+5N3
        5gfvJMuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1huumW-0001fp-Pe; Tue, 06 Aug 2019 08:25:20 +0000
Date:   Tue, 6 Aug 2019 01:25:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, sage@redhat.com,
        ukernel@gmail.com
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for reads
 and writes
Message-ID: <20190806082520.GA30230@infradead.org>
References: <20190805200501.17905-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190805200501.17905-1-jlayton@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 05, 2019 at 04:05:01PM -0400, Jeff Layton wrote:
> Instead, borrow the scheme used by nfs.ko. Buffered writes take the
> i_rwsem exclusively, but buffered reads and all O_DIRECT requests
> take a shared lock, allowing them to run in parallel.

Note that you'll still need an exclusive lock to guard against cache
invalidation for direct writes.  And instead of adding a new lock you
might want to look at the i_rwsem based scheme in XFS (whіch also
happens to be where O_DIRECT originally came from).
