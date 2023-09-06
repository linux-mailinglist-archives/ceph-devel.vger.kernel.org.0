Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2C6793F31
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Sep 2023 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbjIFOps (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 10:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbjIFOpr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 10:45:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D7D1736;
        Wed,  6 Sep 2023 07:45:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049BCC433C7;
        Wed,  6 Sep 2023 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1694011543;
        bh=GINIbrgJ/wbqwcr7cbbcrPaRWjuOYhX9d/efNo6r+RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HIu3kowuHhVL88m52jCsQVRHjE9wABqz8vh/H/w9C2HPHWy3PKvdIf8JLWoOoKKSh
         XyzWcMZtLIdkYGHVsaO8NGydfCWW0nMuW0oy4KLK+sPc/EX6Z5yhdT/+RwQELAPy6D
         jLX1AaxrQf79wBuXea+JBAzajGjfmwUzbmOzt+HE=
Date:   Wed, 6 Sep 2023 15:45:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] ceph: remove the incorrect caps check in _file_size()
Message-ID: <2023090626-overgrown-probation-a58d@gregkh>
References: <20230906121747.618289-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906121747.618289-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 08:17:47PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When truncating the inode the MDS will acquire the xlock for the
> ifile Locker, which will revoke the 'Frwsxl' caps from the clients.
> But when the client just releases and flushes the 'Fw' caps to MDS,
> for exmaple, and once the MDS receives the caps flushing msg it
> just thought the revocation has finished. Then the MDS will continue
> truncating the inode and then issued the truncate notification to
> all the clients. While just before the clients receives the cap
> flushing ack they receive the truncation notification, the clients
> will detecte that the 'issued | dirty' is still holding the 'Fw'
> caps.
> 
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/56693
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

What commit id does this fix?

thanks,

greg k-h
