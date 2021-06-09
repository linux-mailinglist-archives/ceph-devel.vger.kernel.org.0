Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3DC3A16BB
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Jun 2021 16:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbhFIOOw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Jun 2021 10:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234748AbhFIOOw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Jun 2021 10:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623247977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PnpxCpXE+OK/d1mx857yakOYg3PEYfowIxy9riJbP/w=;
        b=TVxdpIeogunCMTPlu9LrzfEroPsxMmXUHcicovn+WmM0JYoRRm5v2e5Kt9MSLAsjaMRVdB
        ny1mZrs/n45RjwpNLZAA2yKa35I7mhKCtGhtaZAPWWrJQ5QddO8/wYrPLWtO15op9CFmeJ
        J7TKKUDn77ZraGE+1tUOzdV+HCzq9Mk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-iXxecqpjNe6S27AMRTz2aA-1; Wed, 09 Jun 2021 10:12:55 -0400
X-MC-Unique: iXxecqpjNe6S27AMRTz2aA-1
Received: by mail-qt1-f197.google.com with SMTP id q6-20020a05622a04c6b0290247f5436033so4817577qtx.5
        for <ceph-devel@vger.kernel.org>; Wed, 09 Jun 2021 07:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=PnpxCpXE+OK/d1mx857yakOYg3PEYfowIxy9riJbP/w=;
        b=e1Cz+b9kfu2zY6acOQjDHSZa79QonKOCqt4eGwCVg9bGXI/H3/E5fE++T+7Zqk/e0A
         e3Uky7Pt+x+BN15eQoci7NjtDVQkW/2j4Z18nUVN07KM9cK+yAOWyxAj0Ar5KJQ2eFFC
         Xv9ySXz6be9eHAY74SKQsU6xVcwNAzeTg8Unhu7JK1aqy8SRmpaEiG+bAPYkLBIdBTyQ
         +ofIG3kNgu03rY5XoaKJ+FBWQe05MCjZUAxRQkXfj3y+Qo0ZkXKaFvyp65Fek+6UY1Mk
         jtAjOVtSjE3n699fbfCJeasgOISoNMwERexfZY0fYNbJhVMqU8Z9GcBTnricSyalFC6e
         NkdQ==
X-Gm-Message-State: AOAM532Zv9vKOoJW9I86tCapPpKZoXuKXU4q6tPW5RfMkpeROAK3ZcgE
        eL5JnVRVwNkHLE/BdVujKWj/Q8+gLtqaZ5tbYsRQL1MZotozMf9H6X6SE2DprVPbECyN2hNyeSC
        NS1QBS5fc/XdgbNgJvZTuPg==
X-Received: by 2002:ac8:7404:: with SMTP id p4mr137294qtq.224.1623247975394;
        Wed, 09 Jun 2021 07:12:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU+1QtdQdklcTPNEB4o1wjdxD819dTkPpGo3SRZ95NgzpDGxT6HUZ23I2/wz66dMLG6bLHgw==
X-Received: by 2002:ac8:7404:: with SMTP id p4mr137275qtq.224.1623247975168;
        Wed, 09 Jun 2021 07:12:55 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 104sm56424qta.90.2021.06.09.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 07:12:54 -0700 (PDT)
Message-ID: <f5a0857ebfb703889f7fe9ac48761f13e99c09bb.camel@redhat.com>
Subject: cephfs kclient session->s_mutex coverage
From:   Jeff Layton <jlayton@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 09 Jun 2021 10:12:54 -0400
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ancient history question for those who worked on the kclient long ago...

I've been seeing some problems during unmounting with the latest kclient
code and have opened a tracker here:

    https://tracker.ceph.com/issues/51158?issue_count=114&issue_position=1&next_issue_id=51112

The issue is that the client can end up queueing an asynchronous iput()
call to put an inode reference, but that can happen after the point
where the workqueues get flushed at unmount time.

We could try to do more workarounds for this, but I keep circling back
to the fact that the session->s_mutex seems to be held over _way_ too
much of the kclient code. Reducing its scope would be a much better fix,
and would probably be beneficial for performance, and we could eliminate
the workaround that added ceph_async_iput().

I know this is ancient history to most of you who originally worked on
this code, but does anyone remember what the session->s_mutex was
intended to protect, particularly in ceph_check_caps() but also in some 

When I've asked in the past, I've gotten some handwavy answers about
ordering of session messages, but I don't think that's a good enough
reason to do this. We shouldn't be relying on sleeping locks to order
messages on the wire. Most of the data that is accessed and altered in
this code seems to be protected by more fine-grained locks.

There's also this:

/*
 * Handle mds reply.
 *
 * We take the session mutex and parse and process the reply immediately.
 * This preserves the logical ordering of replies, capabilities, etc., sent
 * by the MDS as they are applied to our local cache.
 */

...but again, using sleeping locks to do this ordering is problematic.

Can anyone help identify why it was done this way in the first place? If
we drop the s_mutex from some of these codepaths, what sort of ordering
do we need to guarantee? The snap_rwsem seems to have similar issues, so
the same questions apply to it as well.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

