Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF27C537C
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Oct 2023 14:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjJKMTi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Oct 2023 08:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346616AbjJKMTA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Oct 2023 08:19:00 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BDEDB
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 05:18:58 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2bffa8578feso84286361fa.2
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 05:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1697026736; x=1697631536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NVfn9PXw+Xc7MOe9fBZyAc2Mg1C5gfNmbgZDWe8PI8=;
        b=VGX47blj49EGrJ3Z5hHasUthk7DzLZsCCfk4YiMoEI87jCFY+FmJatANiEvjbBy9Tm
         GvLX6PdMgj9ca3VQPHysOOoQgJemxewJlrWkI3KrnNYZ2T631HHURKz04nHAjUiWSRd3
         6JSf11rQkI0jIzjQEENUe4Hhy/yis8tPBXXvmmoh+hAGH6I4lK5K/6RDFFqMjAK0iwIz
         oruZ1zA6IdJi0BZPLjWlrHZznIKHfLGtdSpgzGv+qw2ZehUV8xk+xtriqlU/S520lybN
         5Kv6GmahJdsu8vOvANa+mszqLW5k5ti17nyP+ACw1DQdLAAPsuUdO1DtKJsg/qo5bWPQ
         yUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697026736; x=1697631536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NVfn9PXw+Xc7MOe9fBZyAc2Mg1C5gfNmbgZDWe8PI8=;
        b=bpqFnSA+ybZG/H3KKUHqPOddBESJn3cYe7b7weHQQI2dEWV43PjY/TeMSN/PXipSFJ
         npD5XMM9F2rH9uFuBAa9hmi7V+DRBMeBt81j4dhImxA9FARW1fLaJA9bPuoAsse3a0mp
         1qOw+uJD8UsY6z83XG8hPzHu50ho9X8RTj+LHNx7TAc8U8jIHb7pbv3LhH4SmlnjYKwZ
         eDHgWuDsx7d4Pof75ONmZn2Sr7ngAA0wdjRgjfEiVSgdgVWTP+FS+kNWI20PTuxGgGBW
         9IaGbXvbhew8S3g8OL4GK91k+2a1s4UcUmRgkHFG/WTRl77rwyb5foYEcGkpuBWp7Fax
         TRTA==
X-Gm-Message-State: AOJu0YxE5b1HLsdM/F87bnnwR3q6ijBv8gDzblh4YFNqZznYUb44A2E8
        J4dO3BEhXrIye38/H2b1r+KApGK+0OASFY7IEBPP2A==
X-Google-Smtp-Source: AGHT+IEyeSqa4UE2CD7oJKjtgieZak6mpqiXIKqLTMmoHN4AgmJWnb4Frkvq70Bdg5zQYImvAjshCXozVjO2zOmw3gU=
X-Received: by 2002:a2e:93c5:0:b0:2bf:f3a0:2f9f with SMTP id
 p5-20020a2e93c5000000b002bff3a02f9fmr15021916ljh.4.1697026736637; Wed, 11 Oct
 2023 05:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <69dda7be-d7c8-401f-89f3-7a5ca5550e2f@oracle.com>
 <20231009144340.418904-1-max.kellermann@ionos.com> <20231010131125.3uyfkqbcetfcqsve@quack3>
 <CAKPOu+-nC2bQTZYL0XTzJL6Tx4Pi1gLfNWCjU2Qz1f_5CbJc1w@mail.gmail.com>
 <20231011100541.sfn3prgtmp7hk2oj@quack3> <CAKPOu+_xdFALt9sgdd5w66Ab6KTqiy8+Z0Yd3Ss4+92jh8nCwg@mail.gmail.com>
 <20231011120655.ndb7bfasptjym3wl@quack3>
In-Reply-To: <20231011120655.ndb7bfasptjym3wl@quack3>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Wed, 11 Oct 2023 14:18:45 +0200
Message-ID: <CAKPOu+-hLrrpZShHh0o6uc_KMW91suEd0_V_uzp5vMf4NM-8yw@mail.gmail.com>
Subject: Re: [PATCH v2] fs/{posix_acl,ext2,jfs,ceph}: apply umask if ACL
 support is disabled
To:     Jan Kara <jack@suse.cz>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.com>,
        Dave Kleikamp <shaggy@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        Christian Brauner <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 2:07=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> Indeed, *that* looks like a bug. Good spotting! I'd say posix_acl_create(=
)
> defined in include/linux/posix_acl.h for the !CONFIG_FS_POSIX_ACL case
> should be stripping mode using umask. Care to send a patch for this?

You mean like the patch you're commenting on right now? ;-)

But without the other filesystems. I'll resend it with just the
posix_acl.h hunk.
