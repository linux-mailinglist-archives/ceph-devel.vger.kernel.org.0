Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F038360317C
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Oct 2022 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJRRTz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Oct 2022 13:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJRRTw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Oct 2022 13:19:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D89A20348
        for <ceph-devel@vger.kernel.org>; Tue, 18 Oct 2022 10:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666113591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n4/w6T2c/S8J6lxHxoB0zpSCWLUaWvVWsMys2mjJrt8=;
        b=Fndi3ZbMkdRaKXulR/59IoEQlGCTSsurIBE+35ufq4a7u9bShltmjmID77SEdO43ZHUWbO
        fmN74E+HbEPMNdBV/VzPYKr9wpkOqZq8bpSofBZz8Qw3IfuFNgZbDRXOASrRy+tLgqAjRa
        FIAfv/CfrImosE3ZWZcBR9HK3JJzl/E=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-656-Qt78fCEjM4-AyL5VeAJ9Aw-1; Tue, 18 Oct 2022 13:19:49 -0400
X-MC-Unique: Qt78fCEjM4-AyL5VeAJ9Aw-1
Received: by mail-il1-f199.google.com with SMTP id r12-20020a92cd8c000000b002f9f5baaeeaso12707251ilb.4
        for <ceph-devel@vger.kernel.org>; Tue, 18 Oct 2022 10:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n4/w6T2c/S8J6lxHxoB0zpSCWLUaWvVWsMys2mjJrt8=;
        b=ktP58GdwKER5wqr8qveYyMfnFg09MJMVj44yAVqddmNd3FbhGaD+7xX6Xld0lfmvLp
         icYKUlYoADYGmcmhTTsfBcnu8d0JOPl14PtwbiTJ5CGusBkEQsVrnyWNU6OtwQtlUGBw
         MdzIbCR7bGdniUSxZxsw+cpaIX5H48+rcL82zYHLUobIKhzaivnlUksIygyAw3KPM6Dc
         duyiF1f0z3eWgv/1bK5BlbNM1d7n5HAH5r5rX9WmAidRkRcV3JZNT0uVdvQAs5YjvejJ
         9satmgq75kUmcqCXS0Bs6juG5HfpyjPCYYwDpUT7JErq7L/33dZU3UbCTk/3mlrn+YAn
         U4fg==
X-Gm-Message-State: ACrzQf3E3cUtDARhRV+sHPtOzqOM3REJB3yqTmG8BHesAdhbwa1evV+8
        YpQ9Ms+LE13ROLul4BWeGC48jLh0udsnOuXbjHFpyT7sZKGjc0w8LcZ05gTd6W8HrlZY44i1K2+
        zR+Bljo2AbseDk1m8bfwkkHXD/j3gqLUk8bdPIQ==
X-Received: by 2002:a05:6e02:1c44:b0:2fd:25e0:ca4 with SMTP id d4-20020a056e021c4400b002fd25e00ca4mr2075799ilg.25.1666113588519;
        Tue, 18 Oct 2022 10:19:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM76BT0Wk4lVEvMdUK+jehgz0tujqS3CZ9yas0VCvfTpNPrc1qiVz5THaUzevt3l6yoB+q0m3h4N817f254px1w=
X-Received: by 2002:a05:6e02:1c44:b0:2fd:25e0:ca4 with SMTP id
 d4-20020a056e021c4400b002fd25e00ca4mr2075776ilg.25.1666113588055; Tue, 18 Oct
 2022 10:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAMym5wsABmduNp=JvwutFioiq24Qtm=fniKDDxqatFhpk_teYQ@mail.gmail.com>
In-Reply-To: <CAMym5wsABmduNp=JvwutFioiq24Qtm=fniKDDxqatFhpk_teYQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 18 Oct 2022 10:19:36 -0700
Message-ID: <CAJ4mKGYaNi2HNB4o9SPQgNw5ba0OAOWXDHZLM77KOgnht4--_g@mail.gmail.com>
Subject: Re: Is downburst still maintained?
To:     Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Kyrylo Shatskyy <kyrylo.shatskyy@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 17, 2022 at 7:30 PM Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
>
> Hi,
>
> I've tried to run teuthology in my local environment by following the
> official docs.
> FIrst I tried to use downburst but I found that it hasn't updated for
> a long time.
>
> https://github.com/ceph/downburst
>
> Is downburst still maintained? Currently, I prepare my nodes by
> Vagrant and would
> like to know whether my approach is correct or not.
>

I think downburst is mostly dead at this point. The upstream lab
teuthology instance no longer uses VMs or bursts into the cloud (it
deploys using FOG to raw hardware), and I'm not sure if anybody else
is keeping the run-on-a-cloud portions alive. :/
I see Kyr committed to downburst about a year ago, and most of the
vaguely recent work for clouds was from him and Suse, so maybe he
knows?
-Greg

> Thanks,
> Satoru
>

