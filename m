Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7229356A
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Oct 2020 09:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404706AbgJTHDp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Oct 2020 03:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbgJTHDp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 03:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603177424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pXz1IvHnW/UY742o70tL2os1W+vK9fLKapZGqHPnQgw=;
        b=R7Gor+e1PkRWw8hL89o51wvALPOfdk5ZQ3h9K6oknErtpUzv5aX8AcGZJ05396MeRQewyj
        MAXDeXDx3aZi5lbOvWB1uSCr88LN5Hbs/W97FsUUmoiUIoEoJzU3lYhVZChc6dYQXh287B
        foNqlqP4k4eRvvGj3okLVRvwcVyCHHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-WcuWZFYOO7KJY_hyu3DGRA-1; Tue, 20 Oct 2020 03:03:42 -0400
X-MC-Unique: WcuWZFYOO7KJY_hyu3DGRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22E46802B79;
        Tue, 20 Oct 2020 07:03:41 +0000 (UTC)
Received: from [10.72.12.141] (ovpn-12-141.pek2.redhat.com [10.72.12.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34A966EF6E;
        Tue, 20 Oct 2020 07:03:38 +0000 (UTC)
Subject: Re: [PATCH v4 0/5] ceph: fix spurious recover_session=clean errors
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
References: <20201007121700.10489-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ea6d5fb1-cbad-0478-e165-b7eb32927ede@redhat.com>
Date:   Tue, 20 Oct 2020 15:03:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201007121700.10489-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/10/7 20:16, Jeff Layton wrote:
> v4: test for CEPH_MOUNT_RECOVER in more places
> v3: add RECOVER mount_state and allow dumping pagecache when it's set
>      shrink size of mount_state field
> v2: fix handling of async requests in patch to queue requests
>
> This is the fourth revision of this patchset. The main difference from
> v3 is that this one converts more "==" tests for SHUTDOWN state into
> ">=", so that the RECOVER state is treated the same way.
>
> Original cover letter:
>
> Ilya noticed that he would get spurious EACCES errors on calls done just
> after blocklisting the client on mounts with recover_session=clean. The
> session would get marked as REJECTED and that caused in-flight calls to
> die with EACCES. This patchset seems to smooth over the problem, but I'm
> not fully convinced it's the right approach.
>
> The potential issue I see is that the client could take cap references to
> do a call on a session that has been blocklisted. We then queue the
> message and reestablish the session, but we may not have been granted
> the same caps by the MDS at that point.
>
> If this is a problem, then we probably need to rework it so that we
> return a distinct error code in this situation and have the upper layers
> issue a completely new mds request (with new cap refs, etc.)
>
> Obviously, that's a much more invasive approach though, so it would be
> nice to avoid that if this would suffice.
>
> Jeff Layton (5):
>    ceph: don't WARN when removing caps due to blocklisting
>    ceph: make fsc->mount_state an int
>    ceph: add new RECOVER mount_state when recovering session
>    ceph: remove timeout on allowing reconnect after blocklisting
>    ceph: queue MDS requests to REJECTED sessions when CLEANRECOVER is set
>
>   fs/ceph/addr.c               |  4 ++--
>   fs/ceph/caps.c               |  4 ++--
>   fs/ceph/inode.c              |  2 +-
>   fs/ceph/mds_client.c         | 27 ++++++++++++++++-----------
>   fs/ceph/super.c              | 14 ++++++++++----
>   fs/ceph/super.h              |  3 +--
>   include/linux/ceph/libceph.h |  1 +
>   7 files changed, 33 insertions(+), 22 deletions(-)
>
Reviewed-by: Xiubo Li <xiubli@redhat.com>



