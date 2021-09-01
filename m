Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66E43FE196
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Sep 2021 19:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbhIAR6H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Sep 2021 13:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235811AbhIAR6H (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Sep 2021 13:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630519029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72p27RgYAy11cYdGOVnH4dxrKJARTPiRl2sFnuZiIDw=;
        b=Wn8zTrE2iZA5rjDBUUX6GgzG32Z1Qrb9+oxjpEwCQtYIwS4z3vTeWbImMoPr5f6kqQBptN
        br/ttihkOmux/T+/+f9GbCSi3hVxXFCN7UypvtCan9dlu4r6XzjjaCfL3aU7aHWGjnLiJa
        BkFYXlwbDoPWIk6f1Sd0+ROpWjMRw1o=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-YiW8FTuLOpaXBkRtGUNXOQ-1; Wed, 01 Sep 2021 13:57:08 -0400
X-MC-Unique: YiW8FTuLOpaXBkRtGUNXOQ-1
Received: by mail-qt1-f200.google.com with SMTP id x11-20020ac86b4b000000b00299d7592d31so369307qts.0
        for <ceph-devel@vger.kernel.org>; Wed, 01 Sep 2021 10:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=72p27RgYAy11cYdGOVnH4dxrKJARTPiRl2sFnuZiIDw=;
        b=iGWFjynJM8OvTV9d7dC1eh9XoADlgbrc5rGdCcIv4q79OiQvnNQ9PFbiz/cV1xxk++
         GLgnRps9I5ds9sQQC1K6+5amCHiUb5vr4qOte6QGEyQ6pq8k7vrcq/QIyR2tVOJJ+LE3
         JsTkzROP5FMWxn5C4AzRbDjG0Wrj+c6IK51wybPj8VzlafxLs8+R/5MbhTdfdi24f8lx
         2L36qHywZoIePqkWnJ6a3a2BNqiCjWcArDf/McuHCNaJh+nysU3kKMsMqWJMAEV6XqKb
         YdtasiNRK6lpRjpbEzSxMWjw5ARFTVPj3TZKNdxy+tKS3MdnbPY7EA0Iz5oPveR/1nUf
         ChNg==
X-Gm-Message-State: AOAM532WWo7kx/WlYbd9JY30y2S38Yy+w94t9BjPsn3cG99lFKjM2X2K
        T3D4iyy/ww7juQjFZ0SUQJ6Q0y55voOvXAHJW8BdK7f9n01tkHEPBC67watzg7+hSj4FLuQwvyw
        cIUPXiWMSjhBEWbmlt59QU7IJ1M73UpOOcPDVLQ==
X-Received: by 2002:a05:620a:1671:: with SMTP id d17mr858212qko.191.1630519027767;
        Wed, 01 Sep 2021 10:57:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysCC388YZR39SuqNv5Q7wHG4/cHjJzKIETd2H1z+qzEljroZAaWYLCTw9Bu77aGaWfi+nY9hta994f4cxlGjI=
X-Received: by 2002:a05:620a:1671:: with SMTP id d17mr858176qko.191.1630519027261;
 Wed, 01 Sep 2021 10:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210830234929.GA3817015@onthe.net.au>
In-Reply-To: <20210830234929.GA3817015@onthe.net.au>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 1 Sep 2021 10:56:56 -0700
Message-ID: <CAJ4mKGZN+zAzyMM1+mWuPw5r1v=b-QQrChm+_0nfWtzcbyx=_g@mail.gmail.com>
Subject: Re: New pacific mon won't join with octopus mons
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Why are you trying to create a new pacific monitor instead of
upgrading an existing one?

I *think* what's going on here is that since you're deploying a new
pacific mon, and you're not giving it a starting monmap, it's set up
to assume the use of pacific features. It can find peers at the
locations you've given it, but since they're on octopus there are
mismatches.

Now, I would expect and want this to work so you should file a bug,
but the initial bootstrapping code is a bit hairy and may not account
for cross-version initial setup in this fashion, or have gotten buggy
since written. So I'd try upgrading the existing mons, or generating a
new pacific mon and upgrading that one to octopus if you're feeling
leery.
-Greg

On Mon, Aug 30, 2021 at 4:55 PM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi,
>
> Apologies if this isn't the correct mailing list for this, I've
> already tried getting help for this over on ceph-users but haven't
> received any response:
>
> https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/YHTXK22C7=
CMBWCWKUCSL4U32GLQGBSJG/
>
> I'm not sure, but I suspect this is a bug...
>
> I'm stuck, mid upgrade from octopus to pacific using cephadm, at the
> point of upgrading the mons.
>
> As background, this cluster started life 10 years ago with whatever was
> current at the time, and has been progressively upgraded with each new
> release. It's never had a cephfs on it and I ran into:
>
> https://tracker.ceph.com/issues/51673
>
> I created the temporary cephfs per the ticket and then ran into this
> next problem...
>
> I have 3 mons still on octopus and in quorum. When I try to bring up a
> new pacific mon it stays permanently (over 10 minutes) in "probing"
> state with the pacific ceph-mon chewing up >300% CPU on it's host, and
> causing the octopus ceph-mons on the other hosts to chew up >100% CPU.
> I've left it for 10 minutes in that state and it hasn't progressed
> past "probing".
>
> First up, I'm assuming a pacific mon is supposed to be able to join a
> quorum with octopus mons, otherwise how is an upgrade supposed to
> work?
>
> The pacific mon, "b5", is v16.2.5 running under podman:
>
> docker.io/ceph/ceph@sha256:829ebf54704f2d827de00913b171e5da741aad9b53c1f3=
5ad59251524790eceb
>
> The octopus mons are all v15.2.14. The lead octopus mon ("k2") is
> running under podman:
>
> quay.io/ceph/ceph:v15
>
> The other 2 octopus mons ("b2" and "b4") are standalone
> 15.2.14-1~bpo10+1.  These are manually started due to the cephadm
> upgrade failing at the point of upgrading the mons and leaving me with
> only one cephadm mon running.
>
> On start up of the pacific mon with debug_mon=3D20, over a 30 second
> period I see 765 "handle_probe_reply" sequences by the pacific mon,
> with the lead mon replying 200 times and the other two mons replying
> 279 times each.
>
> In the very first "handle_probe_reply" sequence we see an expected (I
> assume) "bootstrap" as the starting up mon doesn't yet have a monmap
> ("got newer/committed monmap epoch 35, mine was 0"):
>
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e0 handle_probe mon_probe(reply c6618970-0=
ce0-4cb2-bc9a-dd5f29b62e24 name b4 quorum 0,1,2 leader 0 paxos( fc 36513258=
7 lc 365133304 ) mon_release octopus) v7
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e0 handle_probe_reply mon.2 v2:10.200.63.1=
32:3300/0 mon_probe(reply c6618970-0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quor=
um 0,1,2 leader 0 paxos( fc 365132587 lc 365133304 ) mon_release octopus) v=
7
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e0  monmap is e0: 3 mons at {noname-a=3D[v=
2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0],noname-b=3D[v2:10.200.63.13=
2:3300/0,v1:10.200.63.132:6789/0],noname-c=3D[v2:192.168.254.251:3300/0,v1:=
192.168.254.251:6789/0]}
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e0  got newer/committed monmap epoch 35, m=
ine was 0
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 bootstrap
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 sync_reset_requester
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 unregister_cluster_logger - not regist=
ered
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout 0x5646293a0a20
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 monmap e35: 3 mons at {b2=3D[v2:10.200=
.63.130:3300/0,v1:10.200.63.130:6789/0],b4=3D[v2:10.200.63.132:3300/0,v1:10=
.200.63.132:6789/0],k2=3D[v2:192.168.254.251:3300/0,v1:192.168.254.251:6789=
/0]}
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 _reset
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing).auth v0 _set_mon_num_rank num 0 rank 0
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 timecheck_finish
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 15 mon.b5@-1(probing) e35 health_tick_stop
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 15 mon.b5@-1(probing) e35 health_interval_stop
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 scrub_event_cancel
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 scrub_reset
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 reset_probe_timeout 0x5646293a0a20 aft=
er 10 seconds
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 probing other monitors
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 _ms_dispatch new session 0x5646293aafc=
0 MonSession(mon.1 [v2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0] is ope=
n , features 0x3f01cfb8ffedffff (luminous)) features 0x3f01cfb8ffedffff
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700  5 mon.b5@-1(probing) e35 _ms_dispatch setting monitor caps on t=
his connection
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20 mon.b5@-1(probing) e35  entity_name  global_id 0 (none) caps =
allow *
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20 is_capable service=3Dmon command=3D read addr v2:10.200.63.13=
0:3300/0 on cap allow *
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20  allow so far , doing grant allow *
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20  allow all
>
> However every single "handle_probe_reply" sequence after that also
> does a "bootstrap", even though the mon at this point has a monmap
> which the same epoch ("got newer/committed monmap epoch 35, mine was
> 35"), e.g.:
>
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 handle_probe mon_probe(reply c6618970-=
0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quorum 0,1,2 leader 0 paxos( fc 3651325=
87 lc 365133304 ) mon_release octopus) v7
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 handle_probe_reply mon.2 v2:10.200.63.=
132:3300/0 mon_probe(reply c6618970-0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quo=
rum 0,1,2 leader 0 paxos( fc 365132587 lc 365133304 ) mon_release octopus) =
v7
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35  monmap is e35: 3 mons at {b2=3D[v2:10=
.200.63.130:3300/0,v1:10.200.63.130:6789/0],b4=3D[v2:10.200.63.132:3300/0,v=
1:10.200.63.132:6789/0],k2=3D[v2:192.168.254.251:3300/0,v1:192.168.254.251:=
6789/0]}
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35  got newer/committed monmap epoch 35, =
mine was 35
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 bootstrap
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 sync_reset_requester
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 unregister_cluster_logger - not regist=
ered
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout 0x5646293a0a20
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 monmap e35: 3 mons at {b2=3D[v2:10.200=
.63.130:3300/0,v1:10.200.63.130:6789/0],b4=3D[v2:10.200.63.132:3300/0,v1:10=
.200.63.132:6789/0],k2=3D[v2:192.168.254.251:3300/0,v1:192.168.254.251:6789=
/0]}
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 _reset
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing).auth v0 _set_mon_num_rank num 0 rank 0
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 timecheck_finish
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 15 mon.b5@-1(probing) e35 health_tick_stop
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 15 mon.b5@-1(probing) e35 health_interval_stop
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 scrub_event_cancel
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 scrub_reset
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 reset_probe_timeout 0x5646293a0a20 aft=
er 10 seconds
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 10 mon.b5@-1(probing) e35 probing other monitors
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20 mon.b5@-1(probing) e35 _ms_dispatch existing session 0x564629=
3aafc0 for mon.1
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20 mon.b5@-1(probing) e35  entity_name  global_id 0 (none) caps =
allow *
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20 is_capable service=3Dmon command=3D read addr v2:10.200.63.13=
0:3300/0 on cap allow *
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20  allow so far , doing grant allow *
> Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f=
43ead11700 20  allow all
>
> That same sequence keeps repeating, just with the "name" changing
> between the octopus mons, i.e. "name b4", "name b2" and "name k2".
>
> Referencing Monitor::handle_probe_reply() in src/mon/Monitor.cc (see
> also below), if we ever get past the bootstrap() we should get a
> message mentioning "peer", but we never see one.
>
> That implies "mybl.contents_equal(m->monmap_bl)" is never true, and
> "has_ever_joined" is never true.
>
> What's going on here?
>
> Cheers,
>
> Chris
>
> ----------------------------------------------------------------------
> void Monitor::handle_probe_reply(MonOpRequestRef op)
> {
> ...
>    // newer map, or they've joined a quorum and we haven't?
>    bufferlist mybl;
>    monmap->encode(mybl, m->get_connection()->get_features());
>    // make sure it's actually different; the checks below err toward
>    // taking the other guy's map, which could cause us to loop.
>    if (!mybl.contents_equal(m->monmap_bl)) {
>      MonMap *newmap =3D new MonMap;
>      newmap->decode(m->monmap_bl);
>      if (m->has_ever_joined && (newmap->get_epoch() > monmap->get_epoch()=
 ||
>                                 !has_ever_joined)) {
>        dout(10) << " got newer/committed monmap epoch " << newmap->get_ep=
och()
>                 << ", mine was " << monmap->get_epoch() << dendl;
>        delete newmap;
>        monmap->decode(m->monmap_bl);
>        notify_new_monmap(false);
>
>        bootstrap();
>        return;
>      }
>      delete newmap;
>    }
>
>    // rename peer?
>    string peer_name =3D monmap->get_name(m->get_source_addr());
>    if (monmap->get_epoch() =3D=3D 0 && peer_name.compare(0, 7, "noname-")=
 =3D=3D 0) {
>      dout(10) << " renaming peer " << m->get_source_addr() << " "
>               << peer_name << " -> " << m->name << " in my monmap"
>               << dendl;
>      monmap->rename(peer_name, m->name);
>
>      if (is_electing()) {
>        bootstrap();
>        return;
>      }
>    } else if (peer_name.size()) {
>      dout(10) << " peer name is " << peer_name << dendl;
>    } else {
>      dout(10) << " peer " << m->get_source_addr() << " not in map" << den=
dl;
>    }
> ...
> }
> ----------------------------------------------------------------------
>

