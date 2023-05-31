Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A42E717F65
	for <lists+ceph-devel@lfdr.de>; Wed, 31 May 2023 14:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbjEaMBZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 May 2023 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjEaMBY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 May 2023 08:01:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DBF101;
        Wed, 31 May 2023 05:01:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96f5685f902so851686366b.2;
        Wed, 31 May 2023 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685534482; x=1688126482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRE0kYtxcIgn6dpeR8zHtXuRERCfYulH4PpAUPzUjIg=;
        b=AU1EfSrwJ0Fm955ciNvD2IYGmT/UPXVDcAwv/bdgP4w+N15rWi+dy3HlTf9V3Kwsae
         u/gkDoqiFWAlYshvftHDj5SkkxAgYIkf1AnKpiMEjUiGaNF0eSj1ZLzTh7X3ihu5NNy+
         wpF+HVBAkJIkal/8+XGLyLyHsoX3KnJG94DNKqRiTbD5qiZzBrhSla1c9SKr+Z0Gi4KM
         WtLZUV9UJVwnpm21M++xlBvrgs5Vyd5BndaBdxSensqudfz9mbfytLdZLUn+IjRjQ9Sl
         PnVCDh8nzoLR0H8h64iZHx5PaQW+p137uMpicfJAGE582UXH4B9PAJhsgh4Gl3NWCMGY
         dLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685534482; x=1688126482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRE0kYtxcIgn6dpeR8zHtXuRERCfYulH4PpAUPzUjIg=;
        b=VFw/p/7Z6Or1ZAZlJqDOQhy5xG10DVSYFUx3SCzUAR8mm0U/EJ9LjQx6yuSs7xYLaJ
         lBRDGrA7tUS8duHhB88QUZr5dB4vBskH7A7SBCIHIrh4GRlrx8RDb1MAvlTqs/b3GH8a
         g768CVYtZGsqTz6r8TENbgrS3C6C+VLfuWx1eApfk056rI7874PGCUPHEDf2CTrBCRQJ
         QfuoZ8Swk/R/h/Jq6Eg5DvA492sb8j0axanPH1VmS74RiJL6P/lGcuCptmWBE/K2CW+x
         NTdV+eRJM2+r8BpTEGxEW/vGFElZgVUqm8wHbF8ixYLSLtM3HThBcT+tWG1UwiqgIN/s
         xQhg==
X-Gm-Message-State: AC+VfDwMBoQc8BOKINnwqoOLiPUF3CTChGOr58jPRM6CIf3vEz5nu6Zd
        aaU+FyJmi5V6+2WV4cICgqsYuHSrME3T4ErcKKA=
X-Google-Smtp-Source: ACHHUZ5/tdF9uI2EzWZrlrtztStE3UZFjqbpSnMgaJOt6vkU+u2o1wa9x9Fjm+4yCOSuzaEpQb7mj2ElcB7BVqYIEhE=
X-Received: by 2002:a17:906:fd8d:b0:973:e349:43c8 with SMTP id
 xa13-20020a170906fd8d00b00973e34943c8mr5148413ejb.69.1685534481550; Wed, 31
 May 2023 05:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230525024438.507082-1-xiubli@redhat.com> <CAOi1vP8aR=fnbUnpOSJ1yA6Je5c4tS3Ks4xMb10dymYv+y2EgQ@mail.gmail.com>
 <5e82e988-fa03-c580-dc53-0ffdbbc944f5@redhat.com>
In-Reply-To: <5e82e988-fa03-c580-dc53-0ffdbbc944f5@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 31 May 2023 14:01:09 +0200
Message-ID: <CAOi1vP_nX659D-jNThVx3wr63zpiWeSf7-ZE9UJ4V0gdCutOJw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix use-after-free bug for inodes when flushing capsnaps
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 31, 2023 at 1:33=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/31/23 19:09, Ilya Dryomov wrote:
> > On Thu, May 25, 2023 at 4:45=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> There is racy between capsnaps flush and removing the inode from
> >> 'mdsc->snap_flush_list' list:
> >>
> >>     Thread A                            Thread B
> >> ceph_queue_cap_snap()
> >>   -> allocate 'capsnapA'
> >>   ->ihold('&ci->vfs_inode')
> >>   ->add 'capsnapA' to 'ci->i_cap_snaps'
> >>   ->add 'ci' to 'mdsc->snap_flush_list'
> >>      ...
> >> ceph_flush_snaps()
> >>   ->__ceph_flush_snaps()
> >>    ->__send_flush_snap()
> >>                                  handle_cap_flushsnap_ack()
> >>                                   ->iput('&ci->vfs_inode')
> >>                                     this also will release 'ci'
> >>                                      ...
> >>                                  ceph_handle_snap()
> >>                                   ->flush_snaps()
> >>                                    ->iterate 'mdsc->snap_flush_list'
> >>                                     ->get the stale 'ci'
> >>   ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
> >>     'mdsc->snap_flush_list'           will WARNING
> >>
> >> To fix this we will remove the 'ci' from 'mdsc->snap_flush_list'
> >> list just before '__send_flush_snaps()' to make sure the flushsnap
> >> 'ack' will always after removing the 'ci' from 'snap_flush_list'.
> > Hi Xiubo,
> >
> > I'm not sure I'm following the logic here.  If the issue is that the
> > inode can be released by handle_cap_flushsnap_ack(), meaning that ci is
> > unsafe to dereference after the ack is received, what makes e.g. the
> > following snippet in __ceph_flush_snaps() work:
> >
> >      ret =3D __send_flush_snap(inode, session, capsnap, cap->mseq,
> >                              oldest_flush_tid);
> >      if (ret < 0) {
> >              pr_err("__flush_snaps: error sending cap flushsnap, "
> >                     "ino (%llx.%llx) tid %llu follows %llu\n",
> >                      ceph_vinop(inode), cf->tid, capsnap->follows);
> >      }
> >
> >      ceph_put_cap_snap(capsnap);
> >      spin_lock(&ci->i_ceph_lock);
> >
> > If the ack is handled after capsnap is put but before ci->i_ceph_lock
> > is reacquired, could use-after-free occur inside spin_lock()?
>
> Yeah, certainly this could happen.
>
> After the 'ci' being freed it's possible that the 'ci' is still cached
> in the 'ceph_inode_cachep' slab caches or reused by others, so
> dereferring the 'ci' mostly won't crash. But just before freeing 'ci'

Dereferencing an invalid pointer is a major bug regardless of whether
it leads to a crash.  Crashing fast is actually a pretty good case as
far as potential outcomes go.

This needs to be addressed: just removing ci from mdsc->snap_flush_list
earlier obviously doesn't cut it.

Thanks,

                Ilya
