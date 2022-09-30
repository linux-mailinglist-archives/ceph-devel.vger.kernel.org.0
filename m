Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209D25F01AA
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Sep 2022 02:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiI3AER (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Sep 2022 20:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiI3AEQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 29 Sep 2022 20:04:16 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FBB41C481C
        for <ceph-devel@vger.kernel.org>; Thu, 29 Sep 2022 17:04:15 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C6F33613E4;
        Fri, 30 Sep 2022 10:04:12 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id FZSYO5hYt5Cy; Fri, 30 Sep 2022 10:04:12 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 9D54061279;
        Fri, 30 Sep 2022 10:04:12 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 8B3656803CD; Fri, 30 Sep 2022 10:04:12 +1000 (AEST)
Date:   Fri, 30 Sep 2022 10:04:12 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Adam King <adking@redhat.com>,
        Guillaume Abrioux <gabrioux@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220930000412.GB2594730@onthe.net.au>
References: <CAOi1vP9jCHppG7irvLzQgwBSzhrfgc_ak1t2wc=uTOREHVBROA@mail.gmail.com>
 <CAOi1vP8Zfix48tM1ifAgQo1xK+HGC1Sh8mh+Bc=a7Bbv1QENxA@mail.gmail.com>
 <20220928002202.GA2357386@onthe.net.au>
 <CAOi1vP8bk3nj=seT=1jGPzPRVti7j+D1dw_O+zqeUQp9M8T=BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP8bk3nj=seT=1jGPzPRVti7j+D1dw_O+zqeUQp9M8T=BA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

On Thu, Sep 29, 2022 at 01:14:17PM +0200, Ilya Dryomov wrote:
> On Fri, Sep 23, 2022 at 5:58 AM Chris Dunlop <chris@onthe.net.au> wrote:
>> Why is the ceph container getting access to the entire host
>> filesystem in the first place?
...
> Right, I see your point, particularly around /rootfs location making it
> obvious that it's not a standard shell.  I don't have a strong opinion
> here, ultimately the fix is up to Adam and Guillaume (although I would
> definitely prefer a set of targeted mounts over a blanket -v /:/rootfs
> mount, whether slave or not).

Perhaps this topic should be raised at a team meeting or however project 
directions are managed - i.e. whether or not to keep the blanket mount of 
the entire host filesystem or the containers should be aiming for the 
minimal filesystem access required to run. If such a discussion were to 
take place I think the general safety principals around providing minimum 
privileged access should be noted. 


Cheers,

Chris
