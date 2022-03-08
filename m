Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C2C4D1916
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 14:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347086AbiCHNZI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 08:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiCHNZI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 08:25:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419F441996;
        Tue,  8 Mar 2022 05:24:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE0F961022;
        Tue,  8 Mar 2022 13:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A15BC340EB;
        Tue,  8 Mar 2022 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646745851;
        bh=oDHR4xnia2ab55zbZtMiwd3YrjCD0H7NlBw6jy8PM3c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b/LvEGyIil+W4LLfomC8GoZmyEvYMBjFgmwBIW/ORpafjwlqoJ42a3kC1nR6aD7Qo
         lY0388n04hIF2+xQMToeV/CiwLqNuyxUUfNrU6MiP4LfNVv4ap93myb2ypWlSejVKe
         Rt28k1dD+VorawmtOKJEDiPoja1W7CxqxJLmdXX8zEmESwiEylbSvd9itzG28hDbhL
         iWNKNesx6vKqlrjuAqhhNkxGc4WvVLvuHru/0scL+5+NmuEU7YcBs+b/iu6raRIzwM
         UrGtBmajVgzxKA087vGAxrXFZPoodurkUAmHnHtSHfrQvu5qxVXBYMFQ28RpzOzK0j
         M2YmBlX7nDm2A==
Message-ID: <dae26bb75c456e50b196f41966807d05e92b19ff.camel@kernel.org>
Subject: Re: [PATCH] ceph: uninitialized variable in debug output
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Tue, 08 Mar 2022 08:24:08 -0500
In-Reply-To: <1019938.1646732163@warthog.procyon.org.uk>
References: <20220307142121.GB19660@kili>
         <1019938.1646732163@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-08 at 09:36 +0000, David Howells wrote:
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > +	u64 inline_version = -1;
> 
> ULLONG_MAX?
> 
> David
> 

...or maybe CEPH_INLINE_NONE, which is:

    #define CEPH_INLINE_NONE        ((__u64)-1)      
                                                   
-- 
Jeff Layton <jlayton@kernel.org>
