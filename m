Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6852B85BD3
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Aug 2019 09:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbfHHHqk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Aug 2019 03:46:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbfHHHqj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Aug 2019 03:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q1SAyTzJP6sVkKEZOOm+hr0vBdnxq80XJtMGVClto4s=; b=mOuQ1KgW5u2jTwohs7qapCB2+
        tIOF2yyzHZe9NqdAG/Y8nUGAxttvTnsjv4rAyeZL8A/XctifUPLgUaRk6ZrysZpXYp+3Jd/CZ0WuX
        uAeCfPcEp4I81NqQqw1LmAgzD6C5c9SzVK6951C60Rm+P0VilJPPp49rHzRrhVpiHn79nJyepTILz
        LTGNTtE/GFYRFSd0cRYdCJTz0pk2TSo7EmvM6JtSNfhp9hfObH9YR3mClXZDWocwN1JxnRv6hQ9Pc
        b7Ij9Yqq6T1opvUwSDIcOQni0zwyaeeFywd0kAi/7/YPYbrEgPe9h7q1N27p62moR2Kuq3MtPDBiR
        iT5/so40Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hvd8B-0000S8-Cy; Thu, 08 Aug 2019 07:46:39 +0000
Date:   Thu, 8 Aug 2019 00:46:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, sage@redhat.com, ukernel@gmail.com
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for reads
 and writes
Message-ID: <20190808074639.GA1551@infradead.org>
References: <20190805200501.17905-1-jlayton@kernel.org>
 <20190806082520.GA30230@infradead.org>
 <1277d93a52a5c25f4c81f3c34eebced13bf3266d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277d93a52a5c25f4c81f3c34eebced13bf3266d.camel@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 06, 2019 at 06:54:17AM -0400, Jeff Layton wrote:
> That part of the patch description is unclear. I'll fix that up, but
> this patch does ensure that no buffered I/O can take place while any
> direct I/O is in flight. Only operations of the same "flavor" can run
> in parallel. Note that we _do_ use the i_rwsem here, but there is also
> an additional per-inode flag that handles the buffered read/direct I/O
> exclusion.
> 
> I did take a look at the xfs_ilock* code this morning. That's quite a
> bit more complex than this. It's possible that ceph doesn't serialize
> mmap I/O and O_DIRECT properly. I'll have to look over xfstests and see
> whether there is a good test for that as well and whether it passes.

Note that the mmap bits aren't really related to direct vs buffer
locking but for hole punching vs page faults.  As ceph supports hole
punching you'll probably need it too, though.
