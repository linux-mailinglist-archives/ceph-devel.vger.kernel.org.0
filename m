Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB3A564D78
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Jul 2022 07:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiGDF4r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Jul 2022 01:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGDF4q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Jul 2022 01:56:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DCF65AB
        for <ceph-devel@vger.kernel.org>; Sun,  3 Jul 2022 22:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=568VgLApd06h7/G5O2X3xB53xFk3ui6AYPCbu0rpWTE=; b=TMYdT3Ie81Fcf1BgAGxR+7qylt
        PO3k0TGCKLSc5EJlmALATRVVw5Ea57hY1gdHUo85zFi/79fuQw+Yi1B0EUbizx8cER6eCbs4PdmOW
        lg+2NJ6tkf44s3tSM3/aeJHILLOaTXmtRXpo3m2WlIXJ+dl1LYHMO2sBPD36qbOVdII+DqsEsBvu7
        ZnI/XM49SkvDpXTkNimlhJ8FooDBD18IfQJX4I8y8bNoCUtg6lE/F7Fhy7fEBMc5/775aTHCNrtbv
        REiW1ldOKMfKs0Nfz0BkkcwpNDYOmh2mMdN+9TDRk4zk+Ta49WacWpJUfPAjqUe7KMNLLEbZxELfh
        bo/PTvqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8F4c-005DMW-CD; Mon, 04 Jul 2022 05:56:42 +0000
Date:   Sun, 3 Jul 2022 22:56:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] libceph: add new iov_iter msg_data type and use
 it for reads
Message-ID: <YsKBGq99GNpL5jMu@infradead.org>
References: <20220701103013.12902-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701103013.12902-1-jlayton@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 01, 2022 at 06:30:11AM -0400, Jeff Layton wrote:
> Currently, we take an iov_iter from the netfs layer, turn that into an
> array of pages, and then pass that to the messenger which eventually
> turns that back into an iov_iter before handing it back to the socket.
> 
> This patchset adds a new ceph_msg_data_type that uses an iov_iter
> directly instead of requiring an array of pages or bvecs. This allows
> us to avoid an extra allocation in the buffered read path, and should
> make it easier to plumb in write helpers later.
> 
> For now, this is still just a slow, stupid implementation that hands
> the socket layer a page at a time like the existing messenger does. It
> doesn't yet attempt to pass through the iov_iter directly.
> 
> I have some patches that pass the cursor's iov_iter directly to the
> socket in the receive path, but it requires some infrastructure that's
> not in mainline yet (iov_iter_scan(), for instance). It should be
> possible to something similar in the send path as well.

Btw, is there any good reason to not simply replace ceph_msg_data
with an iov_iter entirely?

