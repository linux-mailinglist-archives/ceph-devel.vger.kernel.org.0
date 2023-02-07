Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C7768DD88
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Feb 2023 17:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjBGQDs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Feb 2023 11:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjBGQDq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Feb 2023 11:03:46 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9AB7ED6
        for <ceph-devel@vger.kernel.org>; Tue,  7 Feb 2023 08:03:45 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r3so6437903edq.13
        for <ceph-devel@vger.kernel.org>; Tue, 07 Feb 2023 08:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gTkyByqpMNSCLYvGRPAdB3PrG3GsXjKrtce4hYxj8Zg=;
        b=NZJnOU8EQgOsa2Pbxrm4L09h/37TVEFxDPSt1K44L6Nke3Yfqp2jwNVJBYB+CHqj35
         0/yYfi7kpVKWn+lhsKAFhCFhLcSornOdHoPqmP7uyqZssL/IrL/k1btv9oPtr7bYoEMm
         Fqun4Onw3WnW+CsQVF2k0opfIr+EjLS9SFPv4F+6lsfhMDMRjypm4WEEgLtvSc06E6kV
         aJi+dVFRW2N/Sun8Igm7goslbs1akH9hBhTNb3Ur43Dr06Ff0K5xFxnR8OS8QjCw/enN
         BE5E8nII2wJJJvvL6NU6b7W0iAEvlcxkxaF5c3M9bUO5q+hsCUxMPaaaG8sYDlVLnDgF
         5nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gTkyByqpMNSCLYvGRPAdB3PrG3GsXjKrtce4hYxj8Zg=;
        b=RVQxzwlYfzLO9d6fibQBC4g52d2DzdiRVklj6qUUC7JdgSgs1P76PQgGLFYs00SPO5
         GMaf7qNTXGU3RrB/Le+YR9HVSWwF9g5CTm9jUAeyfEhpW8PzVgVxAmRMWc1TN+WmTQGY
         yWIBb5L6R4JaPOIWnafm3KR+mI4hdA2z9qfuWJ8FDKHdhOHZfJOzFFpbsx2UQ2j/gKeM
         wyzz8KbNE8xSo90i577/hB6v/5aSIfDhzb3IGaAuuNUgZLfUzb8uYqYYSPY3JsxOXuG9
         DnIihccqAaJG0ZbX8bJCie71zzG0aKNzzh/v1+2dgK7PRtNwlNlb+8ZSBamFw4qyGxR0
         i0Ww==
X-Gm-Message-State: AO0yUKUL9By19QEgQhiJ5pjuvV7cyKKbZlvGUE0skLb/WUZW7mV4zfD+
        PDpulD3R2M6OOxA01z1Wo2li1238vQREqkBXy3c=
X-Google-Smtp-Source: AK7set9rQ+opwp/EUdD23xN9hpvfLUte51NoqMNyhqD7theQVaLARWMn6248KDFG6Ch7278C46EoxRklYERIqe+0bfg=
X-Received: by 2002:a50:8e1c:0:b0:4aa:a3c8:72d1 with SMTP id
 28-20020a508e1c000000b004aaa3c872d1mr765998edw.0.1675785824387; Tue, 07 Feb
 2023 08:03:44 -0800 (PST)
MIME-Version: 1.0
References: <20230207050452.403436-1-xiubli@redhat.com> <CACPzV1nrtsfrxJtMxANuaSPbWo5TbQ8roqopxL+VVeUpYOh=3A@mail.gmail.com>
 <f31e08f5-972b-f29c-926a-2586863965f5@redhat.com>
In-Reply-To: <f31e08f5-972b-f29c-926a-2586863965f5@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 7 Feb 2023 17:03:32 +0100
Message-ID: <CAOi1vP9sPucujJrKxy6+-7nGh90VVGtWNrPsZsH5psVW-tcDNA@mail.gmail.com>
Subject: Re: [PATCH] ceph: flush cap release on session flush
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Venky Shankar <vshankar@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, mchangir@redhat.com, lhenriques@suse.de,
        stable@kernel.org, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 7, 2023 at 6:19 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 07/02/2023 13:16, Venky Shankar wrote:
> > On Tue, Feb 7, 2023 at 10:35 AM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> MDS expects the completed cap release prior to responding to the
> >> session flush for cache drop.
> >>
> >> Cc: <stable@kernel.org>
> >> URL: http://tracker.ceph.com/issues/38009
> >> Cc: Patrick Donnelly <pdonnell@redhat.com>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/mds_client.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 3c9d3f609e7f..51366bd053de 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -4039,6 +4039,12 @@ static void handle_session(struct ceph_mds_session *session,
> >>                  break;
> >>
> >>          case CEPH_SESSION_FLUSHMSG:
> >> +               /* flush cap release */
> >> +               spin_lock(&session->s_cap_lock);
> >> +               if (session->s_num_cap_releases)
> >> +                       ceph_flush_cap_releases(mdsc, session);
> >> +               spin_unlock(&session->s_cap_lock);
> >> +
> >>                  send_flushmsg_ack(mdsc, session, seq);
> >>                  break;
> > Ugh. kclient never flushed cap releases o_O
>
> Yeah, I think this was missed before.

Now queued up for 6.2-rc8.

Thanks,

                Ilya
