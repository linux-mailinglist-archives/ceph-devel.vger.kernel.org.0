Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FAF542801
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 09:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiFHHio (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 03:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbiFHGuI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 02:50:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FC6111BB2
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 23:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WfsxOjFvkAp6NK3I3ZKqgiQK30uctYPrQVq3uqyuAG0=; b=ywMtm4rTB/XLULBfv/QjWFaibk
        6uo84uO5j4YPw5Q7cgpd6CyaW+wRLrOQ8rfwXxAd6JDZ8Qg3siZYNkZL39Wg3DvH1VbtbiozQ+a/J
        X1bJYuvTrJSjYxsQVE/HXrU9zQl3OqnpXPfd7KwKr4o0yF7y5Cq16netrNzFXXiMdlClTZbD1bWlk
        wvJailvhA7NCeM/mAgx+zhLynOXnIsx626iPE6g2LIeRnbniSa8MjYi+Qh8QxnFXKr3XfD/4FWENY
        cP7jbTTaLEImlWATtPLsxL5yc20dBg3hT7mA3rAjDc8twhOk6JQfuicqI2G8ZgYGX+qY2uH52Zsda
        3RXiorvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nypJz-00BJue-4v; Wed, 08 Jun 2022 06:37:39 +0000
Date:   Tue, 7 Jun 2022 23:37:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: don't implement writepage
Message-ID: <YqBDs+u6qUHOprMv@infradead.org>
References: <20220607112703.17997-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607112703.17997-1-jlayton@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Do you have an urgent need for this?  I was actually planning on sending
a series to drop ->writepage entirely in the next weeks, and I'd pick
this patch up to avoid conflicts if possible.

Note that you also need to implement ->migratepage to not lose any
functionality if dropping ->writepage, and comeing up with a good
solution for that is what has been delaying the series.
