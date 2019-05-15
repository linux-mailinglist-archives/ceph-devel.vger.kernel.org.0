Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683991FCA4
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2019 00:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfEOWsC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 15 May 2019 18:48:02 -0400
Received: from mail-it1-f175.google.com ([209.85.166.175]:40565 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEOWsC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 18:48:02 -0400
Received: by mail-it1-f175.google.com with SMTP id g71so2902809ita.5
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 15:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HBHT3WRiJ4iIZQVFg+pifSH40e7dddZdbrVh9dqRMkc=;
        b=EK3pkLM5xLliJ6huAur6QLYZV0sTexsEucXq8HUspfNE2Y7tUDoDaxRV3UNMPkHbj/
         grU3FfA0FuVBeL07HEhFSKGfDLynAHsMPkyIKjCbw4Hf34Mqdja9ytvQvFdf9G35kLHj
         92NWMPVjvk+6xoGZ+/Act3e/ZV2xHt9CxpkFU26ZslE2OpcyT0lDoTvtJFLqXGz95fVe
         CkQwBmvOUovSJPkmbmlYda9noOq3RI3BZOEV9G6HQRExkocxu1yV9cIwuQI1OEhu5ytB
         I8vHCAsqnNgu1WFW3hiaMhBJ9YgdfoQcgAj40Oob+8lL/peVs23ogm4Yik63/N2KNU3p
         b/tw==
X-Gm-Message-State: APjAAAUYhzmNoXsnDqoIGpprAERJv0eRJY6M62E6WoO6LUi8MiZ3FCp+
        1e/z2x76a0Plb0av1RAaIAXbmALnTgWbnD1+5PWX7jzF
X-Google-Smtp-Source: APXvYqzKw0MspeAoJaMtEPj7GLpZzSG5JeP1akrn08zzKCx7mbMIu05AYbV7w2RSI+Di/Kptn+cvf4GU+A+kRYw2/zQ=
X-Received: by 2002:a02:c54f:: with SMTP id g15mr8880139jaj.106.1557960481078;
 Wed, 15 May 2019 15:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <1e522eba-fc1f-ccd3-97e6-106411b1ddeb@redhat.com>
In-Reply-To: <1e522eba-fc1f-ccd3-97e6-106411b1ddeb@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 15 May 2019 15:47:48 -0700
Message-ID: <CAJ4mKGZ=EjC=_VQkCmRgjGj4AkFnXZbC5YFn1NnOYPQkb2D=zg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Proposal_=E2=80=93_DaemonWatchdog?=
To:     Jos Collin <jcollin@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I never really worked out why the FS tests were susceptible to these
issues but the core RADOS thrashing tasks weren't. If you're planning
to expand the DaemonWatchdog you probably want to work that out. Maybe
just because the ceph_manager thrashing does a lot of restarting
proactively? Or do the MDS thrash tasks just not pay attention to the
daemon state until the end of the test and the rados thrashing watches
more carefully in the normal course of doing business?
-Greg

On Tue, May 14, 2019 at 10:40 PM Jos Collin <jcollin@redhat.com> wrote:
>
> Hi,
>
> This is a proposal for DaemonWatchdog improvements based on the bug:
> http://tracker.ceph.com/issues/11314. Sending it to ceph-devel for
> getting suggestions.
>
> Current Functionality
> ---------------------
> DaemonWatchdog watches the Ceph daemons for failures. If an extended
> failure is detected (i.e. not intentional), then the watchdog unmount
> file systems and send SIGTERM to all daemons. The duration of an
> extended failure is configurable with  watchdog_daemon_timeout. The
> watchdog_daemon_timeout (default value: 300) is the number of seconds a
> daemon is allowed to be failed before the watchdog barks (unmounting the
> mounts and killing all the daemons).
>
> DaemonWatchdog was originally written for watching the mds (and mon)
> daemons for failures. It unmounts the mounted filesystems and kill the
> mds (and mon) daemons.
>
> Proposed Improvement
> --------------------
> As per John's suggestion here:
> http://tracker.ceph.com/issues/11314#note-1, it would be better if we
> extend this functionality to watch the other daemons too like osd, mon,
> rgw and mgr and do the necessary action or logging (bark) when those
> daemons crashes. We need to make those improvements in watch() and
> bark() functions, so that if the daemon crashes unexpectedly, we detect
> it immediately rather than waiting a long time for a timeout of some
> kind. The bark() function should have different cases to handle
> different daemons crashing. The procedure to be executed for ‘mds’ case
> is present in the bark() function now. But we need to decide the
> procedures for ‘osd’, ‘mon’, ‘rgw’ and ‘mgr’ cases. I think killing the
> daemons and throwing/logging errors or maybe just throwing an error
> would be sufficient.
>
> * At present the class DaemonWatchdog is written in mds_thrash.py, as it
> is specific for watching mds daemons. It would be better if we move it
> out of mds_thrash.py to be generic, to a new file
> qa/tasks/daemonwatchdog.py.
>
> * The current code tries to watch the 'client'?
> (https://github.com/ceph/ceph/blob/master/qa/tasks/mds_thrash.py#L87). I
> have dropped this statement, as it is difficult to watch what the client
> is doing in general.
>
> * There is a suggestion to add the DaemonWatchdog to ceph.py and have it
> always run whenever Ceph is "started".
>
> Thanks,
> Jos Collin
