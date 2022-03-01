Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F34C8CF1
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 14:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiCANuS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 08:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiCANuS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 08:50:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66895E12
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 05:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646142572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=pmOyrVp9ACkhck676p3JiJUvCDTwZfJa29gRgw4iZdQ=;
        b=i6+hHo22j2+XdbOmX+5jVBvTkT1xcAJrWpyc3TPeIfutMFnaioBxKd6aoWI8kmksOjGbFD
        MaCI6srHgRZOh3UA6tzhIFOhZSwN3Oq8f1jjJfED+NzSrP44zTtBWoQbEy0pp70Wt1N/Kn
        ZN9rt5mWujQFSAZYaA7E6H1orHzfBp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-Jnc8_IUKPXqiByohe-epTw-1; Tue, 01 Mar 2022 08:49:31 -0500
X-MC-Unique: Jnc8_IUKPXqiByohe-epTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49194FC85;
        Tue,  1 Mar 2022 13:49:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FE317C020;
        Tue,  1 Mar 2022 13:49:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>
cc:     dhowells@redhat.com, Ceph Development <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Making 3 ceph patches available to rebase netfslib patches on
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3079338.1646142563.1@warthog.procyon.org.uk>
Date:   Tue, 01 Mar 2022 13:49:23 +0000
Message-ID: <3079339.1646142563@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

Could you pick three ceph commits onto the branch you're going to use for the
next merge window?  They're on the testing branch, but I'm assuming that's not
going to be presented to Linus, given the do-not-merge commits it also has on
it.

I'd like to rebase my netfslib patchset on it so that we don't have two views
of the same thing.

The three commits are:

9579e41d45c961a52ffa619c4a77d78f2f782c19
ceph: switch netfs read ops to use rreq->inode instead of rreq->mapping->host

85fc162016ac8d19e28877a15f55c0fa4b47713b
ceph: Make ceph_netfs_issue_op() handle inlined data 

f9ee82ff4db2310eb4ba5458ef08f89eaa0b0c20
ceph: Uninline the data on a file opened for writing

Thanks,
David

