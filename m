Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2BB4B9687
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 04:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiBQDTK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 22:19:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiBQDTJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 22:19:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B46726E7BF
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 19:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645067934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6K3rC1PHy/hXmpDUlj3pCxHWej2kvgfhOuEMDSX0T0A=;
        b=gQDZ3usCjw+izTwFrzIvJ2bh4eA8vhSJ25PKZdD1/UdBMglhgepo35Sh5wqSsX7aCFrCQb
        EQZtQ327bI/zgI3T6DgR1ArFiumyzFqIVtLfmrMgVXrQCJiXlP1JN5G+JL8dof+iIcdCeH
        vamPMyWlWWCsamVpXHEmCPzPzXD0eZM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-DV3j-0PUNj2woxGf5Nwrlw-1; Wed, 16 Feb 2022 22:18:53 -0500
X-MC-Unique: DV3j-0PUNj2woxGf5Nwrlw-1
Received: by mail-qk1-f199.google.com with SMTP id q5-20020ae9dc05000000b00507225deac5so2988852qkf.5
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 19:18:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6K3rC1PHy/hXmpDUlj3pCxHWej2kvgfhOuEMDSX0T0A=;
        b=NAx8mbv9WlvVjJGuEZe8ZMvZpU84NFqg50t/yy1VUvWMzxAIXLs/CMwIKCC62UVn5X
         9Gor5XAmjOVWan9OhI6Ytwahh/mQVW0tZQWkfRvIeZZQelvx3i7VzKalhidp+DN6/fJv
         YYuUL0RouRRaMyXg9WwwhTdAPyZBCgd7RN7IX7mou/TbUd2k1LFOlyLsKgsmlnGA6Fyk
         8vlTZTWAZM5PWzrFH1CW3hue95waQypYBstq7d1mNEZUzyBt/3exhPrrE5W1sfEfRy4Z
         VTXlDTFHNm8nCbXCVYxtef+0rDQsuQ+RCzi8jxRnLkqdDBMQztSiN//aN1wIUMIHrPMu
         IHSw==
X-Gm-Message-State: AOAM530Mv130MuyZJiy18JIdLRYaZ74XfTMys8xbfq91EyVTsYlj4dkw
        rbVa9xege2HDnjpBhTHAkYg8J8y54vo1oGrOLO3dwpaWput89XOriB1grMJof2oHKYJXvWNTU25
        Kkq+kVlfubiMqLY4sg53mM2OZ/bTGCABHWyLz+g==
X-Received: by 2002:a05:620a:284d:b0:5ff:320d:c0a5 with SMTP id h13-20020a05620a284d00b005ff320dc0a5mr487400qkp.681.1645067933390;
        Wed, 16 Feb 2022 19:18:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxD7lJGVGv2AZuUyPo03BtDOX3qME34SYTFKWY5SKKYso6X5pPDR4PD9EL7RLJ/6rp6arl4jNU3/RtDeZ6kAE=
X-Received: by 2002:a05:620a:284d:b0:5ff:320d:c0a5 with SMTP id
 h13-20020a05620a284d00b005ff320dc0a5mr487393qkp.681.1645067933029; Wed, 16
 Feb 2022 19:18:53 -0800 (PST)
MIME-Version: 1.0
References: <20220207050340.872893-1-xiubli@redhat.com> <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
 <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
 <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
 <CAJ4mKGb3j_QNMuKmccoj43jswoReb_iP8wnJi3f-mpaN++PC7w@mail.gmail.com>
 <9ee4afece5bc3445ed19a3344a11eeab697ff37e.camel@kernel.org> <3e2d66b0-a0e9-be31-a803-f7a4ff687c78@redhat.com>
In-Reply-To: <3e2d66b0-a0e9-be31-a803-f7a4ff687c78@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 16 Feb 2022 19:18:40 -0800
Message-ID: <CAJ4mKGYr+9YkWPVtnXUMdF5yvw1mi8Mi7BoLV-9nzdfxfO9xVQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an ESTALE
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Dan van der Ster <dan@vanderster.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 8, 2022 at 10:00 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 2/8/22 1:11 AM, Jeff Layton wrote:
> > On Mon, 2022-02-07 at 08:28 -0800, Gregory Farnum wrote:
> >> On Mon, Feb 7, 2022 at 8:13 AM Jeff Layton <jlayton@kernel.org> wrote:
> >>> The tracker bug mentions that this occurs after an MDS is restarted.
> >>> Could this be the result of clients relying on delete-on-last-close
> >>> behavior?
> >> Oooh, I didn't actually look at the tracker.
> >>
> >>> IOW, we have a situation where a file is opened and then unlinked, and
> >>> userland is actively doing I/O to it. The thing gets moved into the
> >>> strays dir, but isn't unlinked yet because we have open files against
> >>> it. Everything works fine at this point...
> >>>
> >>> Then, the MDS restarts and the inode gets purged altogether. Client
> >>> reconnects and tries to reclaim his open, and gets ESTALE.
> >> Uh, okay. So I didn't do a proper audit before I sent my previous
> >> reply, but one of the cases I did see was that the MDS returns ESTALE
> >> if you try to do a name lookup on an inode in the stray directory. I
> >> don't know if that's what is happening here or not? But perhaps that's
> >> the root of the problem in this case.
> >>
> >> Oh, nope, I see it's issuing getattr requests. That doesn't do ESTALE
> >> directly so it must indeed be coming out of MDCache::path_traverse.
> >>
> >> The MDS shouldn't move an inode into the purge queue on restart unless
> >> there were no clients with caps on it (that state is persisted to disk
> >> so it knows). Maybe if the clients don't make the reconnect window
> >> it's dropping them all and *then* moves it into purge queue? I think
> >> we need to identify what's happening there before we issue kernel
> >> client changes, Xiubo?
> >
> > Agreed. I think we need to understand why he's seeing ESTALE errors in
> > the first place, but it sounds like retrying on an ESTALE error isn't
> > likely to be helpful.
>
> There has one case that could cause the inode to be put into the purge
> queue:
>
> 1, When unlinking a file and just after the unlink journal log is
> flushed and the MDS is restart or replaced by a standby MDS. The unlink
> journal log will contain the a straydn and the straydn will link to the
> related CInode.
>
> 2, The new starting MDS will replay this unlink journal log in
> up:standby_replay state.
>
> 3, The MDCache::upkeep_main() thread will try to trim MDCache, and it
> will possibly trim the straydn. Since the clients haven't reconnected
> the sessions, so the CInode won't have any client cap. So when trimming
> the straydn and CInode, the CInode will be put into the purge queue.
>
> 4, After up:reconnect, when retrying the getattr requests the MDS will
> return ESTALE.
>
> This should be fixed in https://github.com/ceph/ceph/pull/41667
> recently, it will just enables trim() in up:active state.
>
> I also went through the ESTALE related code in MDS, this patch still
> makes sense and when getting an ESTALE errno to retry the request make
> no sense.

Thanks for checking; this sounds good to me.

Acked-by: Greg Farnum <gfarnum@redhat.com>

>
> BRs
>
> Xiubo
>
>

