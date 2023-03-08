Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34F96AFE6E
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 06:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCHFeN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 00:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHFeM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 00:34:12 -0500
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 21:34:02 PST
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0890D8C0F2
        for <ceph-devel@vger.kernel.org>; Tue,  7 Mar 2023 21:34:01 -0800 (PST)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 0B1C16185B
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 16:24:01 +1100 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id VpPXKdAwsBZk for <ceph-devel@vger.kernel.org>;
        Wed,  8 Mar 2023 16:24:00 +1100 (AEDT)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id D3ADF6180A
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 16:24:00 +1100 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id B126A68044F; Wed,  8 Mar 2023 16:24:00 +1100 (AEDT)
Date:   Wed, 8 Mar 2023 16:24:00 +1100
From:   Chris Dunlop <chris@onthe.net.au>
To:     ceph-devel@vger.kernel.org
Subject: Upgrade 16.2.9 to 16.2.11 stopped due to #57627
Message-ID: <ZAgb8KZ5NWEkAWWF@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Just to note this:

ceph-volume activate takes time to complete
https://tracker.ceph.com/issues/57627

...is a show stopper bug for me in 16.2.11 when trying to upgrade from 
16.2.9 - in particular to get this fix:

Pacific: Significant write amplification as compared to Nautilus
https://tracker.ceph.com/issues/58530

The upgrade to 16.2.11 stopped with:

$ ceph orch upgrade status
{
     "target_image": "quay.io/ceph/ceph@sha256:748387ea347157fb9df9bb2620d873ac633ff80d0308bcc82a74a821df0d0cfa",
     "in_progress": true,
     "which": "Upgrading all daemon types on all hosts",
     "services_complete": [
         "mon",
         "mgr"
     ],
     "progress": "10/90 daemons upgraded",
     "message": "Error: UPGRADE_REDEPLOY_DAEMON: Upgrading daemon osd.24 on host b2 failed.",
     "is_paused": true
}

Likely because that "b2" host is getting bitten VERY badly by the 
"ceph-volume activate takes time to complete" problem due to a large 
number of block devices on the system:

b2$ lsblk -P -p -o 'NAME' | wc -l
924

Attempting to start the affected osd via systemd was failing due to timing out.
I tried manually starting the osd per it's unit.run, but the "ceph-volume
activate" step was running for over an hour before I gave up.

I've been able to manually revert this particular OSD (the first one to be
updated on this particular box) back to 16.2.9 by updating it's unit.run 
file and restarting the osd, so my cluster is healthy.

I see the fix has been backported:

https://tracker.ceph.com/issues/58790

I'm guessing it shouldn't be too much of a problem running mixed versions 
for a while until 16.2.12 comes out?

$ ceph versions
{
     "mon": {
         "ceph version 16.2.9 (4c3647a322c0ff5a1dd2344e039859dcbd28c830) pacific (stable)": 5
     },
     "mgr": {
         "ceph version 16.2.9 (4c3647a322c0ff5a1dd2344e039859dcbd28c830) pacific (stable)": 3
     },
     "osd": {
         "ceph version 16.2.11 (3cf40e2dca667f68c6ce3ff5cd94f01e711af894) pacific (stable)": 2,
         "ceph version 16.2.9 (4c3647a322c0ff5a1dd2344e039859dcbd28c830) pacific (stable)": 79
     },
     "mds": {},
     "overall": {
         "ceph version 16.2.11 (3cf40e2dca667f68c6ce3ff5cd94f01e711af894) pacific (stable)": 2,
         "ceph version 16.2.9 (4c3647a322c0ff5a1dd2344e039859dcbd28c830) pacific (stable)": 87
     }
}


Cheers,

Chris
