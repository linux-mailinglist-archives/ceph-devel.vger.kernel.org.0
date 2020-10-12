Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE4928B880
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 15:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbgJLNxN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 09:53:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390267AbgJLNwp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602510762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WsXTDkyIbOizIrVkwsN72/EQq+sxMexGHXGiNCF/bPE=;
        b=ZK+oIzK20SCkHPV8qx9dJbThUf2OgRlWq8fP31BsYstRJ9PLskhMwbknasHtNuQzYnardY
        nzvTszglNICUU0IsitibMHg5yvGRPm+eFxMiffajiho7BOzKN0RGca1yDg8R6kBayDNtI2
        AS9fGLE9HNjP7DVBo7HY3cgfgE8g89M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-3GcN5pmVNz6Om5ekZoN13w-1; Mon, 12 Oct 2020 09:52:38 -0400
X-MC-Unique: 3GcN5pmVNz6Om5ekZoN13w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 775E21084C81;
        Mon, 12 Oct 2020 13:52:37 +0000 (UTC)
Received: from [10.72.12.177] (ovpn-12-177.pek2.redhat.com [10.72.12.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46CBA5C225;
        Mon, 12 Oct 2020 13:52:34 +0000 (UTC)
Subject: Re: [PATCH] ceph: retransmit REQUEST_CLOSE every second if we don't
 get a response
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
References: <20200928220349.584709-1-jlayton@kernel.org>
 <CAOi1vP8zXLGscoa4QjiwW0BtbVnrkamWGzBeqARnVr8Maes3CQ@mail.gmail.com>
 <53e9b5c4635f4aa0f51c0c1870a72fc96d88bd10.camel@kernel.org>
 <CAOi1vP8w5kfVcsVL0n5UG3Ks4vNOEbW-wX-UMsniKPt5rE6nSA@mail.gmail.com>
 <b2a93049-969e-f889-e773-e326230b0efb@redhat.com>
 <5f41bef292d90066c650aa2e960beb5a1b11fbad.camel@kernel.org>
 <860ed81f-c8ab-c482-18ce-0080cedd3ec1@redhat.com>
 <2be66f15a6e9217863b4c0bb4004c9263b768e26.camel@kernel.org>
 <41f84b63-e517-cdb7-c76a-548f9bf0fe96@redhat.com>
 <f48a9c6dbc199081674f0f3eccaf394a3ff74643.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ae35089e-1770-c151-3406-0310a76ce9d8@redhat.com>
Date:   Mon, 12 Oct 2020 21:52:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <f48a9c6dbc199081674f0f3eccaf394a3ff74643.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/10/12 21:49, Jeff Layton wrote:
> On Mon, 2020-10-12 at 21:31 +0800, Xiubo Li wrote:
>> On 2020/10/12 21:17, Jeff Layton wrote:
>>> On Mon, 2020-10-12 at 20:41 +0800, Xiubo Li wrote:
>>>> On 2020/10/12 19:52, Jeff Layton wrote:
>>>>> On Mon, 2020-10-12 at 14:52 +0800, Xiubo Li wrote:
>>>>>> On 2020/10/11 2:49, Ilya Dryomov wrote:
>>>>>>> On Thu, Oct 8, 2020 at 8:14 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>>>> On Thu, 2020-10-08 at 19:27 +0200, Ilya Dryomov wrote:
>>>>>>>>> On Tue, Sep 29, 2020 at 12:03 AM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>>>>>> Patrick reported a case where the MDS and client client had racing
>>>>>>>>>> session messages to one anothe. The MDS was sending caps to the client
>>>>>>>>>> and the client was sending a CEPH_SESSION_REQUEST_CLOSE message in order
>>>>>>>>>> to unmount.
>>>>>>>>>>
>>>>>>>>>> Because they were sending at the same time, the REQUEST_CLOSE had too
>>>>>>>>>> old a sequence number, and the MDS dropped it on the floor. On the
>>>>>>>>>> client, this would have probably manifested as a 60s hang during umount.
>>>>>>>>>> The MDS ended up blocklisting the client.
>>>>>>>>>>
>>>>>>>>>> Once we've decided to issue a REQUEST_CLOSE, we're finished with the
>>>>>>>>>> session, so just keep sending them until the MDS acknowledges that.
>>>>>>>>>>
>>>>>>>>>> Change the code to retransmit a REQUEST_CLOSE every second if the
>>>>>>>>>> session hasn't changed state yet. Give up and throw a warning after
>>>>>>>>>> mount_timeout elapses if we haven't gotten a response.
>>>>>>>>>>
>>>>>>>>>> URL: https://tracker.ceph.com/issues/47563
>>>>>>>>>> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
>>>>>>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>>>>>>> ---
>>>>>>>>>>      fs/ceph/mds_client.c | 53 ++++++++++++++++++++++++++------------------
>>>>>>>>>>      1 file changed, 32 insertions(+), 21 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>>>>>> index b07e7adf146f..d9cb74e3d5e3 100644
>>>>>>>>>> --- a/fs/ceph/mds_client.c
>>>>>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>>>>>> @@ -1878,7 +1878,7 @@ static int request_close_session(struct ceph_mds_session *session)
>>>>>>>>>>      static int __close_session(struct ceph_mds_client *mdsc,
>>>>>>>>>>                              struct ceph_mds_session *session)
>>>>>>>>>>      {
>>>>>>>>>> -       if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
>>>>>>>>>> +       if (session->s_state > CEPH_MDS_SESSION_CLOSING)
>>>>>>>>>>                     return 0;
>>>>>>>>>>             session->s_state = CEPH_MDS_SESSION_CLOSING;
>>>>>>>>>>             return request_close_session(session);
>>>>>>>>>> @@ -4692,38 +4692,49 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
>>>>>>>>>>             return atomic_read(&mdsc->num_sessions) <= skipped;
>>>>>>>>>>      }
>>>>>>>>>>
>>>>>>>>>> +static bool umount_timed_out(unsigned long timeo)
>>>>>>>>>> +{
>>>>>>>>>> +       if (time_before(jiffies, timeo))
>>>>>>>>>> +               return false;
>>>>>>>>>> +       pr_warn("ceph: unable to close all sessions\n");
>>>>>>>>>> +       return true;
>>>>>>>>>> +}
>>>>>>>>>> +
>>>>>>>>>>      /*
>>>>>>>>>>       * called after sb is ro.
>>>>>>>>>>       */
>>>>>>>>>>      void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>>>>>>>>>>      {
>>>>>>>>>> -       struct ceph_options *opts = mdsc->fsc->client->options;
>>>>>>>>>>             struct ceph_mds_session *session;
>>>>>>>>>> -       int i;
>>>>>>>>>> -       int skipped = 0;
>>>>>>>>>> +       int i, ret;
>>>>>>>>>> +       int skipped;
>>>>>>>>>> +       unsigned long timeo = jiffies +
>>>>>>>>>> +                             ceph_timeout_jiffies(mdsc->fsc->client->options->mount_timeout);
>>>>>>>>>>
>>>>>>>>>>             dout("close_sessions\n");
>>>>>>>>>>
>>>>>>>>>>             /* close sessions */
>>>>>>>>>> -       mutex_lock(&mdsc->mutex);
>>>>>>>>>> -       for (i = 0; i < mdsc->max_sessions; i++) {
>>>>>>>>>> -               session = __ceph_lookup_mds_session(mdsc, i);
>>>>>>>>>> -               if (!session)
>>>>>>>>>> -                       continue;
>>>>>>>>>> -               mutex_unlock(&mdsc->mutex);
>>>>>>>>>> -               mutex_lock(&session->s_mutex);
>>>>>>>>>> -               if (__close_session(mdsc, session) <= 0)
>>>>>>>>>> -                       skipped++;
>>>>>>>>>> -               mutex_unlock(&session->s_mutex);
>>>>>>>>>> -               ceph_put_mds_session(session);
>>>>>>>>>> +       do {
>>>>>>>>>> +               skipped = 0;
>>>>>>>>>>                     mutex_lock(&mdsc->mutex);
>>>>>>>>>> -       }
>>>>>>>>>> -       mutex_unlock(&mdsc->mutex);
>>>>>>>>>> +               for (i = 0; i < mdsc->max_sessions; i++) {
>>>>>>>>>> +                       session = __ceph_lookup_mds_session(mdsc, i);
>>>>>>>>>> +                       if (!session)
>>>>>>>>>> +                               continue;
>>>>>>>>>> +                       mutex_unlock(&mdsc->mutex);
>>>>>>>>>> +                       mutex_lock(&session->s_mutex);
>>>>>>>>>> +                       if (__close_session(mdsc, session) <= 0)
>>>>>>>>>> +                               skipped++;
>>>>>>>>>> +                       mutex_unlock(&session->s_mutex);
>>>>>>>>>> +                       ceph_put_mds_session(session);
>>>>>>>>>> +                       mutex_lock(&mdsc->mutex);
>>>>>>>>>> +               }
>>>>>>>>>> +               mutex_unlock(&mdsc->mutex);
>>>>>>>>>>
>>>>>>>>>> -       dout("waiting for sessions to close\n");
>>>>>>>>>> -       wait_event_timeout(mdsc->session_close_wq,
>>>>>>>>>> -                          done_closing_sessions(mdsc, skipped),
>>>>>>>>>> -                          ceph_timeout_jiffies(opts->mount_timeout));
>>>>>>>>>> +               dout("waiting for sessions to close\n");
>>>>>>>>>> +               ret = wait_event_timeout(mdsc->session_close_wq,
>>>>>>>>>> +                                        done_closing_sessions(mdsc, skipped), HZ);
>>>>>>>>>> +       } while (!ret && !umount_timed_out(timeo));
>>>>>>>>>>
>>>>>>>>>>             /* tear down remaining sessions */
>>>>>>>>>>             mutex_lock(&mdsc->mutex);
>>>>>>>>>> --
>>>>>>>>>> 2.26.2
>>>>>>>>>>
>>>>>>>>> Hi Jeff,
>>>>>>>>>
>>>>>>>>> This seems wrong to me, at least conceptually.  Is the same patch
>>>>>>>>> getting applied to ceph-fuse?
>>>>>>>>>
>>>>>>>> It's a grotesque workaround, I will grant you. I'm not sure what we want
>>>>>>>> to do for ceph-fuse yet but it does seem to have the same issue.
>>>>>>>> Probably, we should plan to do a similar fix there once we settle on the
>>>>>>>> right approach.
>>>>>>>>
>>>>>>>>> Pretending to not know anything about the client <-> MDS protocol,
>>>>>>>>> two questions immediately come to mind.  Why is MDS allowed to drop
>>>>>>>>> REQUEST_CLOSE?
>>>>>>>> It really seems like a protocol design flaw.
>>>>>>>>
>>>>>>>> IIUC, the idea overall with the low-level ceph protocol seems to be that
>>>>>>>> the client should retransmit (or reevaluate, in the case of caps) calls
>>>>>>>> that were in flight when the seq number changes.
>>>>>>>>
>>>>>>>> The REQUEST_CLOSE handling seems to have followed suit on the MDS side,
>>>>>>>> but it doesn't really make a lot of sense for that, IMO.
>>>>>>> (edit of my reply to https://github.com/ceph/ceph/pull/37619)
>>>>>>>
>>>>>>> After taking a look at the MDS code, it really seemed like it
>>>>>>> had been written with the expectation that REQUEST_CLOSE would be
>>>>>>> resent, so I dug around.  I don't fully understand these "push"
>>>>>>> sequence numbers yet, but there is probably some race that requires
>>>>>>> the client to confirm that it saw the sequence number, even if the
>>>>>>> session is about to go.  Sage is probably the only one who might
>>>>>>> remember at this point.
>>>>>>>
>>>>>>> The kernel client already has the code to retry REQUEST_CLOSE, only
>>>>>>> every five seconds instead every second.  See check_session_state()
>>>>>>> which is called from delayed_work() in mds_client.c.  It looks like
>>>>>>> it got broken by Xiubo's commit fa9967734227 ("ceph: fix potential
>>>>>>> mdsc use-after-free crash") which conditioned delayed_work() on
>>>>>>> mdsc->stopping -- hence the misbehaviour.
>>>>>> Without this commit it will hit this issue too. The umount old code will
>>>>>> try to close sessions asynchronously, and then tries to cancel the
>>>>>> delayed work, during which the last queued delayed_work() timer might be
>>>>>> fired. This commit makes it easier to be reproduced.
>>>>>>
>>>>> Fixing the potential races to ensure that this is retransmitted is an
>>>>> option, but I'm not sure it's the best one. Here's what I think we
>>>>> probably ought to do:
>>>>>
>>>>> 1/ fix the MDS to just ignore the sequence number on REQUEST_CLOSE. I
>>>>> don't see that the sequence number has any value on that call, as it's
>>>>> an indicator that the client is finished with the session, and it's
>>>>> never going to change its mind and do something different if the
>>>>> sequence is wrong. I have a PR for that here:
>>>>>
>>>>>        https://github.com/ceph/ceph/pull/37619
>>>>>
>>>>> 2/ fix the clients to not wait on the REQUEST_CLOSE reply. As soon as
>>>>> the call is sent, tear down the session and proceed with unmounting. The
>>>>> client doesn't really care what the MDS has to say after that point, so
>>>>> we may as well not wait on it before proceeding.
>>>>>
>>>>> Thoughts?
>>>> I am thinking possibly we can just check the session's state when the
>>>> client receives a request from MDS which will increase the s_seq number,
>>>> if the session is in CLOSING state, the client needs to resend the
>>>> REQUEST_CLOSE request again.
>>>>
>>> That could be done, but that means adding extra complexity to the
>>> session handling code, which could really stand to be simplified
>>> instead.
>>>
>>> mdsc->stopping and session->s_state seem to be protected by the
>>> mdsc->mutex, but session->s_seq is protected by the session->s_mutex.
>>>
>>> There are 4 types of messages that increment the s_seq -- caps, leases,
>>> quotas and snaps. All of those would need to be changed to check for and
>>> retransmit REQUEST_CLOSE if one is outstanding.
>> How about deferring resending the CLOSE request in the above case ?
>>
> I'm not sure I follow you here. What would deferring the resend help
> with here? Bear in mind that the client is unmounting at this point so
> we really do want to get on with the business of tearing things down and
> not wait around any longer than we need.

Okay, please just ignore it.

BRs


>
>>> So yeah, that could be done on the client side. If we were to do that,
>>> should we couple it with the MDS side fix to make it ignore the seq on
>>> REQUEST_CLOSE?
>>

