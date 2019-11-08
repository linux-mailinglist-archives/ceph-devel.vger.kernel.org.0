Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFC0F51CA
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 17:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfKHQ6v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 11:58:51 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36309 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfKHQ6v (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Nov 2019 11:58:51 -0500
Received: by mail-il1-f194.google.com with SMTP id s75so5739305ilc.3;
        Fri, 08 Nov 2019 08:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbcdpktrbXS6Yowcc4gjz10LUAcVoUBnf3DKhGRoD9A=;
        b=pCNhQjYf2wxGkF/0uM6a+eXLDUNo2L9AQNAo574430FFUigplcVyNU//0bZzPOwzHs
         T8ntbZc/S2tBxjqt2dSkn3PV6xJo/Vi0+1DJ5wn+YrRgxi7FWRS6BduIPfayoOhRG575
         NvJQNm08a6sdqX2keVjIuxvf6aSPXWRzKhnrP88vdianXd7k0LIzzEbkBwNLlM3WpIc2
         fZWysjLs6sKuSfjWEVFqQIwyTr29lwLPbm7ZR9t9RoyqnrEZzNdc5h5JbbZXia3WK510
         85I8qAON8XhgGVlLu9hufe7ZHbWchcrafGv26g2zxbFXOjhpvlel1paWNJeW852KO9on
         O27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbcdpktrbXS6Yowcc4gjz10LUAcVoUBnf3DKhGRoD9A=;
        b=RwLQaiPTxTXkBTmKtdWfIoP4a3LmwY4Xbua9mkPSh2KdKNcsO3+KebRjSi4FuJDzzH
         YoI5qBDzyGaHv9SfGY4j7N8bIlnmq4vpXqZiRNHNXb5k9xCC9POMJwNjAzbIppqS2N5z
         NOlW3nMefO5qJ52JBCpWfqewNoRMwJEr6/mGY2qcxqH2ANgrmH62wueBtdWFwkrHM4QP
         DJlOzQ/CfME65A5cxXmqmm7DLrzkx+p3CSOc9Y8yih5/CZWsVoPCPHB7mFrWXTMnZqdL
         mW/9HOlaUIUOKcR/IeBlY/LasX30HEQBlPKYP8M7E46QBly9yZUeUl+ujTzmeKr0J1BZ
         ErQg==
X-Gm-Message-State: APjAAAWbdwguZ9TKa/JnGi2c27/t5u6z9YyHR1r9ceipFwIuVfX7WOxH
        hdKRxv095n7RFX8bcEyOywaETEv/eR9JtuTMjmo=
X-Google-Smtp-Source: APXvYqxDMOOR80yTZtqBscgZ9zFMMSP+fJVkqKa/WBzRFjLOhIvdg+w3wkn720Sf6IwE7ejJS6tMovhq5iuU5LwuFyI=
X-Received: by 2002:a92:7945:: with SMTP id u66mr12713157ilc.215.1573232329842;
 Fri, 08 Nov 2019 08:58:49 -0800 (PST)
MIME-Version: 1.0
References: <20191108141555.31176-1-lhenriques@suse.com> <CAOi1vP-sVQKvpiPLoZ=9s7Hy=c2eQRocxSs1nPrXAUCbbZUZ-g@mail.gmail.com>
 <20191108164758.GA1760@hermes.olymp>
In-Reply-To: <20191108164758.GA1760@hermes.olymp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 8 Nov 2019 17:59:12 +0100
Message-ID: <CAOi1vP-2DkFMZqdWd1BEk-fRA5mV+0so5XD946cmMcBGw=ZQ4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus OSDs
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Nov 8, 2019 at 5:48 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Fri, Nov 08, 2019 at 04:15:35PM +0100, Ilya Dryomov wrote:
> > On Fri, Nov 8, 2019 at 3:15 PM Luis Henriques <lhenriques@suse.com> wrote:
> > >
> > > Hi!
> > >
> > > (Sorry for the long cover letter!)
> >
> > This is exactly what cover letters are for!
> >
> > >
> > > Since the fix for [1] has finally been merged and should be available in
> > > the next (Octopus) ceph release, I'm trying to clean-up my kernel client
> > > patch that tries to find out whether or not it's safe to use the
> > > 'copy-from' RADOS operation for copy_file_range.
> > >
> > > So, the fix for [1] was to modify the 'copy-from' operation to allow
> > > clients to optionally (using the CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ
> > > flag) send the extra truncate_seq and truncate_size parameters.  Since
> > > only Octopus will have this fix (no backports planned), the client
> > > simply needs to ensure the OSDs being used have SERVER_OCTOPUS in their
> > > features.
> > >
> > > My initial solution was to add an extra test in __submit_request,
> > > looping all the request ops and checking if the connection has the
> > > required features for that operation.  Obviously, at the moment only the
> > > copy-from operation has a restriction but I guess others may be added in
> > > the future.  I believe that doing this at this point (__submit_request)
> > > allows to cover cases where a cluster is being upgraded to Octopus and
> > > we have different OSDs running with different feature bits.
> > >
> > > Unfortunately, this solution is racy because the connection state
> > > machine may be changing and the peer_features field isn't yet set.  For
> > > example: if the connection to an OSD is being re-open when we're about
> > > to check the features, the con->state will be CON_STATE_PREOPEN and the
> > > con->peer_features will be 0.  I tried to find ways to move the feature
> > > check further down in the stack, but that can't be easily done without
> > > adding more infrastructure.  A solution that came to my mind was to add
> > > a new con->ops, invoked in the context of ceph_con_workfn, under the
> > > con->mutex.  This callback could then verify the available features,
> > > aborting the operation if needed.
> > >
> > > Note that the race in this patchset doesn't seem to be a huge problem,
> > > other than occasionally reverting to a VFS generic copy_file_range, as
> > > -EOPNOTSUPP will be returned here.  But it's still a race, and there are
> > > probably other cases that I'm missing.
> > >
> > > Anyway, maybe I'm missing an obvious solution for checking these OSD
> > > features, but I'm open to any suggestions on other options (or some
> > > feedback on the new callback in ceph_connection_operations option).
> > >
> > > [1] https://tracker.ceph.com/issues/37378
> >
> > If the OSD checked for unknown flags, like newer syscalls do, it would
> > be super easy, but it looks like it doesn't.
> >
> > An obvious solution is to look at require_osd_release in osdmap, but we
> > don't decode that in the kernel because it lives the OSD portion of the
> > osdmap.  We could add that and consider the fact that the client now
> > needs to decode more than just the client portion a design mistake.
> > I'm not sure what can of worms does that open and if copy-from alone is
> > worth it though.  Perhaps that field could be moved to (or a copy of it
> > be replicated in) the client portion of the osdmap starting with
> > octopus?  We seem to be running into it on the client side more and
> > more...
>
> I can't say I'm thrilled with the idea of going back to hack into the
> OSDs code again, I was hoping to be able to handle this with the
> information we already have on the connection peer_features field.  It
> took me *months* to have the OSD fix merged in so I'm not really
> convinced a change to the osdmap would make it into Octopus :-)
>
> (But I'll have a look at this and see if I can understand what moving or
> replicating the field in the osdmap would really entail.)

Just to be clear: I'm not suggesting that you do it ;)  More of an
observation that something that is buried deep in the OSD portion of
the osdmap is being needed increasingly by the clients.

Thanks,

                Ilya
