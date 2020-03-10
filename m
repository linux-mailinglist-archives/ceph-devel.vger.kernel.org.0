Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93BF17FE6C
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 14:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgCJMo7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 08:44:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:36442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgCJMo5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7D95AC67;
        Tue, 10 Mar 2020 12:44:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 10 Mar 2020 13:44:55 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] libceph: fix memory leak for messages allocated with
 CEPH_MSG_DATA_PAGES
In-Reply-To: <CAOi1vP8S6xTpbNaeRHZ=pKOf4vbw03LxT5RbheDMSHidDPGr+w@mail.gmail.com>
References: <20200310090924.49788-1-rpenyaev@suse.de>
 <CAOi1vP9chc5PZD8SpSKXWMec2jMgESQuoAqkwy5GpF61Qs2Uhg@mail.gmail.com>
 <9998629d1021eb8c2bd3a1bd5c2d87c8@suse.de>
 <CAOi1vP8S6xTpbNaeRHZ=pKOf4vbw03LxT5RbheDMSHidDPGr+w@mail.gmail.com>
Message-ID: <5e1f57d6f17b43ea99052a082b584190@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020-03-10 11:40, Ilya Dryomov wrote:

[skip]

>> And seems if the ownership of the ->pages is transferred to
>> the handle_watch_notify() and freed there, then it should be
>> fixed by having release in one place: here or there.
> 
> The problem is that at least at one point CEPH_MSG_DATA_PAGES needed
> a reference count -- it couldn't be freed it in one place.  pagelists
> are reference counted, but can't be easily swapped in, hence that TODO.
> 
> Thanks for reminding me about this.  I'll take a look -- perhaps the
> reference count is no longer required and we can get away with a simple
> flag.

To my shallow understanding handle_watch_notify() also has an error
path which eventually does not free or take ownership of data->pages,
e.g. callers of 'goto out_unlock_osdc'. Probably code relies on the
fact, that sender knows what is doing and never sends ->data with
wrong cookie or opcode, but looks very suspicious to me.

Seems for this particular DATA_PAGES case it is possible just to
take an ownership by zeroing out data->pages and data->length,
which prevents double free, something as the following:

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b68b376d8c2f..15ae6377c461 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4440,6 +4440,8 @@ static void handle_watch_notify(struct 
ceph_osd_client *osdc,
                                         
ceph_release_page_vector(data->pages,
                                                calc_pages_for(0, 
data->length));
                                 }
+                               data->pages = NULL;
+                               data->length = 0;
                         }
                         lreq->notify_finish_error = return_code;


and keeping the current patch with explicit call of
ceph_release_page_vector from ceph_msg_data_destroy() from
messenger.c.

--
Roman


