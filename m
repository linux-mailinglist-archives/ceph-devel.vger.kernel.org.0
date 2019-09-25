Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491D9BE6C7
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 23:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393487AbfIYVAy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 17:00:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391186AbfIYVAy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 17:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569445252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ubfvEwQLZg+YQfGV+2mYGYK3XKaAvLb9NPsa9tCZM4=;
        b=d3KTJXgF6HfFq8eAhTVdzJ1PxwhdrB7Oz3JqBER2GgP61G6W5Dstx1C4zP5jRpcRMKkNSv
        pfEFvezKPfzNHsh9SLguTbF9SmgHTOvL6wsYzuvPy8dGwQ6JdtVj+eUn2Q7TyxtllABRnT
        nGoR/oOH2a5cZKi7qGzl38cH7FdFSpM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178--dfJWla_PriMhnIsLn3ctA-1; Wed, 25 Sep 2019 17:00:51 -0400
Received: by mail-qt1-f197.google.com with SMTP id m19so210088qtm.13
        for <ceph-devel@vger.kernel.org>; Wed, 25 Sep 2019 14:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WS+TvqmpyvcQt3Y1mK2L6L6eJFfgG+8+8B/MGIu1nAU=;
        b=HULJyCrcDTUVby8OA1VJiVwWkTvAh8P3V4V4KT7pcTw9FFm0QMicAWWM0BPV8eo+xR
         KmmJoCB5K3L8vRMmY2MW/855B4bPFRZY7a5vzdhMLImDrqFa34RFn9j0TMKflGqaTCYG
         xAZvtQOJZY2paEukb/DOIiU8MhNoUvMs1wlmm3TEg+jsqNC6tcxfY9vkuChH6MIAKYBO
         IhvKATxBNny1U5BbWwh2s89cGLsRFjIeLCEDB+TnMFOCYdYiDoPHCy14Zs0N88cvz4iy
         Ik0wBZwasYpyNcnulr9YtiWQkXQeYSUqRVidJKbCi1GN7YAJIB+9RWnOG9Ge4mDI5/sZ
         gQ8g==
X-Gm-Message-State: APjAAAVF/RE/hvaU9Bla/O8+1+bletig5FD0ogoO5hfHoC7Q51KkSztK
        AuAPv7QqP3L2i0YmasMCvxM85u0rN974HscohLc8XUDjkEQekGJnFQq+ACXy1coBRHq8ueYpGsm
        RleWomcd3arjbgHmjimxjh1yVfn7vdGVl80ek6Q==
X-Received: by 2002:a37:4bd2:: with SMTP id y201mr6126522qka.85.1569445250464;
        Wed, 25 Sep 2019 14:00:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydM+tFI+291zwrrk7Hg+yg6AExsYdFHPDDEmed1VmSVx8l3J7czYveO7mRiZkfMb6nsm9cF5QTFiY2d/QU2bo=
X-Received: by 2002:a37:4bd2:: with SMTP id y201mr6126443qka.85.1569445249721;
 Wed, 25 Sep 2019 14:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAPHfcngzug4HDzHtZcb80xdf-NZFNjc2Q7r3vJWSHJufjcgKKQ@mail.gmail.com>
In-Reply-To: <CAPHfcngzug4HDzHtZcb80xdf-NZFNjc2Q7r3vJWSHJufjcgKKQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 25 Sep 2019 14:00:38 -0700
Message-ID: <CAJ4mKGY0g00sZCpn-BEBh+ohNkeC6K56bNFbXVRurHWcfEzd2g@mail.gmail.com>
Subject: Re: RADOS EC: is it okay to reduce the number of commits required for
 reply to client?
To:     Alex Xu <alexu4993@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ceph Users <ceph-users@lists.ceph.com>
X-MC-Unique: -dfJWla_PriMhnIsLn3ctA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 12:06 AM Alex Xu <alexu4993@gmail.com> wrote:
>
> Hi Cephers,
>
> We are testing the write performance of Ceph EC (Luminous, 8 + 4), and
> noticed that tail latency is extremly high. Say, avgtime of 10th
> commit is 40ms, acceptable as it's an all HDD cluster; 11th is 80ms,
> doubled; then 12th is 160ms, doubled again, which is not so good. Then
> we made a small modification and tested again, and did get a much
> better result. The patch is quite simple (for test only of course):
>
> --- a/src/osd/ECBackend.cc
> +++ b/src/osd/ECBackend.cc
> @@ -1188,7 +1188,7 @@ void ECBackend::handle_sub_write_reply(
>      i->second.on_all_applied =3D 0;
>      i->second.trace.event("ec write all applied");
>    }
> -  if (i->second.pending_commit.empty() && i->second.on_all_commit) {
> +  if (i->second.pending_commit.size() =3D=3D 2 &&
> i->second.on_all_commit) {  // 8 + 4 - 10 =3D 2
>      dout(10) << __func__ << " Calling on_all_commit on " << i->second <<=
 dendl;
>      i->second.on_all_commit->complete(0);
>      i->second.on_all_commit =3D 0;
>
> As far as what I see, everything still goes well (maybe because of the
> rwlock in primary OSD? not sure though), but I'm afraid it might break
> data consistency in some ways not aware of. So I'm writing to ask if
> someone could kindly provide expertise comments on this or maybe share
> any known drawbacks. Thank you!

Unfortunately this is one of those things that will work okay in
everyday use but fail catastrophically if something else goes wrong.

Ceph assumes throughout its codebase that if a write committed to
disk, it can be retrieved as long as k OSDs are available from the
PG's acting set when that write was committed. But by letting writes
"commit" on less than the full acting set, you might lose some of the
OSDs which *did* ack the write and no longer be able to find out what
it was even though you have >k OSDs available!

This will result in a very, very confused Ceph recovery algorithm,
lots of badness, and unhappy cluster users. :(
-Greg

>
> PS: OSD is backended with filestore, not bluestore, if that matters.
>
> Regards,
> Alex

