Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E591E408755
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 10:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhIMIr5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 04:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhIMIr5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Sep 2021 04:47:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41EFC061574;
        Mon, 13 Sep 2021 01:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qBEtqyBRKy0FvVPGp0L6p55j5QPlsxKY9JnLfBHA49E=; b=i0ArtbFcISHx/+zkmIgm9gt9eP
        8DqMOV0idSMksIUuIZj/5KqUCMLiYoWJxKpzHTV7pK/VUBLpoZb7ahqlRERcFzwH31HDQaThxVl43
        BZvPQRj5iBZqwL2T/X2KCzYFz0j/3GoScGq0++Eb02HmjkihQ2sBvXKJJXRioffdFXEOLam9/rU9X
        ipcuTGkZWu9Dg+3jT6k5KgkNr4qzz9MPEjbkzDKNHvHZtDrNHhaBhta5KZXk82X8Vyy9+cmZ5g8BI
        IEugeXG4i3WpSD+Vv0rkJlgg7wQBZIDAnAOJSN+yZ7Ch4D58iAdfkcRZbZYqDGE8EyForyC75s6mY
        QB3m2e2A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPhXw-00DKDH-Aa; Mon, 13 Sep 2021 08:42:46 +0000
Date:   Mon, 13 Sep 2021 09:42:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan H??ppner <hoeppner@linux.ibm.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, chaitanya.kulkarni@wdc.com,
        atulgopinathan@gmail.com, hare@suse.de, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, colin.king@canonical.com,
        shubhankarvk@gmail.com, baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] s390/block/dasd_genhd: add error handling support
 for add_disk()
Message-ID: <YT8O/NL2pEGUjYj9@infradead.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-7-mcgrof@kernel.org>
 <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 13, 2021 at 10:17:48AM +0200, Jan H??ppner wrote:
> I think, just like with some of the other changes, there is some
> cleanup required before returning. I'll prepare a patch and
> come back to you.

If you are touching the dasd probe path anyway, can you look insto
switching to use blk_mq_alloc_disk as well?  Right now dasd allocates
the request_queue and gendisk separately in different stages of
initialization, but unlike SCSI which needs to probe using just the
request_queue I can't find a good reason for that.
