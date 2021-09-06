Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86814018BB
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbhIFJSh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 05:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240430AbhIFJSd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 05:18:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A44DC061575;
        Mon,  6 Sep 2021 02:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rpadY60xuZTsVqlD3pQoJaPqU3ClhmKBmxShxdIOPTQ=; b=PnvC6D5zqQVeRqwnkETdG9hYJx
        ljEOQvj4My7mUimGhEI1YNMlvjzbX7PGi2zUTMQmJQhK8Hns7uGt6hka0lnZFNJAsdlAaOCNA5Avs
        NFC6y8Agrp38qMbZLj6Tj0rySktHbY+AwC3htRPHpABgcJqs8/5c+0iuqiIe27xLRytx/rNIEpsqO
        ZWyWai5d2hrS9T6DmndX82cTyQCL5YmLldG/mmJW3nN7w1ac5T6SGMgp6R2RTc+Co9HFSjtZPr4IR
        8uf10wSIJ9a97lAjpGFuZeLuQ8W7X29RmhQVxfn5mxKuCE4/SfrEts5ru+wBawqcL8BDuPky7nXVI
        GZT9W8mA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mNAj6-006oEv-Fr; Mon, 06 Sep 2021 09:15:52 +0000
Date:   Mon, 6 Sep 2021 10:15:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, chaitanya.kulkarni@wdc.com,
        atulgopinathan@gmail.com, hare@suse.de, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, colin.king@canonical.com,
        shubhankarvk@gmail.com, baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] s390/block/xpram: add error handling support for
 add_disk()
Message-ID: <YTXcPBph323n2WJ8@infradead.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-10-mcgrof@kernel.org>
 <YTIr1w/qPvgioUfL@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTIr1w/qPvgioUfL@osiris>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 03, 2021 at 04:06:15PM +0200, Heiko Carstens wrote:
> Hmm, this is a more or less dead device driver, and I'm wondering if
> we shouldn't remove it instead. But anyway, your patch is not correct:

I'm all for removing it.  I think we need to do a little more spring
cleaning on unmaintained and likely to be unused block drivers.
