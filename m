Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F67256C1
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 10:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbjFGIEF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 04:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbjFGIEE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 04:04:04 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EDE8E;
        Wed,  7 Jun 2023 01:04:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-977d7bdde43so69031066b.0;
        Wed, 07 Jun 2023 01:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686125042; x=1688717042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQeSGI2ehCtt28cMSM0j/8JROdCQpNtOuBUEPEk+izY=;
        b=UaZce0kdJ253KPmQD/Ug89rbzWmVLaMH9Uw8fzPkFB0Dh0Kwo8QyFNpK7p9PS1JmLU
         Be9J3f/eDXvZJutlE03eVc92GG2Us5qwSa01vbgbia1wa/NyVA+i5Ew0XkwTmyaV08AI
         NrMzJ8UlfZrmK3rZ55nRF1uZDBeZp+9FM+5eV23k7lGntAUOZkZgHY59UXBliwi91oFV
         7eZ/HVRj8MwvLfaEoxFQW7m/tnvIdvQxEurGleeIfm29iUKwMfRaOn16dIcgUBpooY/e
         V3K4T4Zf2nJU56ghZD2+lthmHP3KRwM4weimVQd1yjiNQhkHyVmhMX9KXOUWpsZs7X8H
         Rmaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686125042; x=1688717042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQeSGI2ehCtt28cMSM0j/8JROdCQpNtOuBUEPEk+izY=;
        b=lj7MWFekee/XvARCadnYc9z3clJXlKHXbiKREwU8yi0MgVWdTDx/wzrLFr8XCAqJtc
         XCAD8O3mj6AhIdmDkc6FSbmzFSw5y1ZYmRki/wbd2FnTVGKNC3kNkErzfxJhJKv03qOL
         nljcQ0Qi+kk1Bw3HsaGwbSVHf062cEXljDKEPRbReSCtFMWySziO9bFHjN3UTdmlh73D
         xT9l4ScIoZY33JR7Acn8d8j+6weGbLwTmUnL8pHVVLPFZP90wg2iDPjqtDr0L7unvDQG
         BKbf2fXSe/0xjpbxfvcWioJ3sWxAWWwgiDkwtOKsgZdxrOylOkKwh0/pSYUzZ2WMFQ0W
         jrXg==
X-Gm-Message-State: AC+VfDzwHDTigplIYe23X1tKGCfvisR6szy5dQQzKtt9DmZtr4GR0a6z
        dRves0Gstm3RmMFQvKqPYYs5NPNq2G5uelPEXOg=
X-Google-Smtp-Source: ACHHUZ6hlpNALNNDFT3bLhUI6jxaeSMa8EzFbhiXQB/Ccb0P7i6a5Pqcv5GUZqWM9UetdMcSpiI9+GdxFHIbp9garWc=
X-Received: by 2002:a17:907:1c93:b0:977:d27e:dd5f with SMTP id
 nb19-20020a1709071c9300b00977d27edd5fmr5270843ejc.28.1686125041474; Wed, 07
 Jun 2023 01:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230606005253.1055933-1-xiubli@redhat.com> <CAOi1vP_Xr6iMgjo7RKtc4-oZdF_FX7_U3Wx4Y=REdpa4Gj7Oig@mail.gmail.com>
 <b0ec84e4-1999-8284-dc90-307831f1e04b@redhat.com>
In-Reply-To: <b0ec84e4-1999-8284-dc90-307831f1e04b@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Jun 2023 10:03:49 +0200
Message-ID: <CAOi1vP_ma6pQ35FpG6wEYBhwxRXYB73vP-B1Jziji7zDodDpGQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: fix use-after-free bug for inodes when flushing capsnaps
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
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

On Tue, Jun 6, 2023 at 3:30=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/6/23 18:21, Ilya Dryomov wrote:
> > On Tue, Jun 6, 2023 at 2:55=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> There is a race between capsnaps flush and removing the inode from
> >> 'mdsc->snap_flush_list' list:
> >>
> >>     =3D=3D Thread A =3D=3D                     =3D=3D Thread B =3D=3D
> >> ceph_queue_cap_snap()
> >>   -> allocate 'capsnapA'
> >>   ->ihold('&ci->vfs_inode')
> >>   ->add 'capsnapA' to 'ci->i_cap_snaps'
> >>   ->add 'ci' to 'mdsc->snap_flush_list'
> >>      ...
> >>     =3D=3D Thread C =3D=3D
> >> ceph_flush_snaps()
> >>   ->__ceph_flush_snaps()
> >>    ->__send_flush_snap()
> >>                                  handle_cap_flushsnap_ack()
> >>                                   ->iput('&ci->vfs_inode')
> >>                                     this also will release 'ci'
> >>                                      ...
> >>                                        =3D=3D Thread D =3D=3D
> >>                                  ceph_handle_snap()
> >>                                   ->flush_snaps()
> >>                                    ->iterate 'mdsc->snap_flush_list'
> >>                                     ->get the stale 'ci'
> >>   ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
> >>     'mdsc->snap_flush_list'           will WARNING
> >>
> >> To fix this we will increase the inode's i_count ref when adding 'ci'
> >> to the 'mdsc->snap_flush_list' list.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D2209299
> >> Reviewed-by: Milind Changire <mchangir@redhat.com>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> V3:
> >> - Fix two minor typo in commit comments.
> >>
> >>
> >>
> >>   fs/ceph/caps.c | 6 ++++++
> >>   fs/ceph/snap.c | 4 +++-
> >>   2 files changed, 9 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index feabf4cc0c4f..7c2cb813aba4 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -1684,6 +1684,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci=
,
> >>          struct inode *inode =3D &ci->netfs.inode;
> >>          struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)-=
>mdsc;
> >>          struct ceph_mds_session *session =3D NULL;
> >> +       int put =3D 0;
> > Hi Xiubo,
> >
> > Nit: renaming this variable to need_put and making it a bool would
> > communicate the intent better.
>
> Hi Ilya
>
> Sure, will update it.
>
> >>          int mds;
> >>
> >>          dout("ceph_flush_snaps %p\n", inode);
> >> @@ -1728,8 +1729,13 @@ void ceph_flush_snaps(struct ceph_inode_info *c=
i,
> >>                  ceph_put_mds_session(session);
> >>          /* we flushed them all; remove this inode from the queue */
> >>          spin_lock(&mdsc->snap_flush_lock);
> >> +       if (!list_empty(&ci->i_snap_flush_item))
> >> +               put++;
> > What are the cases when ci is expected to not be on snap_flush_list
> > list (and therefore there is no corresponding reference to put)?
> >
> > The reason I'm asking is that ceph_flush_snaps() is called from two
> > other places directly (i.e. without iterating snap_flush_list list) and
> > then __ceph_flush_snaps() is called from two yet other places.  The
> > problem that we are presented with here is that __ceph_flush_snaps()
> > effectively consumes a reference on ci.  Is ci protected from being
> > freed by handle_cap_flushsnap_ack() very soon after __send_flush_snap()
> > returns in all these other places?
>
> There are 4 places will call the 'ceph_flush_snaps()':
>
> Cscope tag: ceph_flush_snaps
>     #   line  filename / context / line
>     1   3221  fs/ceph/caps.c <<__ceph_put_cap_refs>>
>               ceph_flush_snaps(ci, NULL);
>     2   3336  fs/ceph/caps.c <<ceph_put_wrbuffer_cap_refs>>
>               ceph_flush_snaps(ci, NULL);
>     3   2243  fs/ceph/inode.c <<ceph_inode_work>>
>               ceph_flush_snaps(ci, NULL);
>     4    941  fs/ceph/snap.c <<flush_snaps>>
>               ceph_flush_snaps(ci, &session);
> Type number and <Enter> (q or empty cancels):
>
> For #1 it will add the 'ci' to the 'mdsc->snap_flush_list' list by
> calling '__ceph_finish_cap_snap()' and then call the
> 'ceph_flush_snaps()' directly or defer call it in the queue work in #3.
>
> The #3 is the reason why we need the 'mdsc->snap_flush_list' list.
>
> For #2 it won't add the 'ci' to the list because it will always call the
> 'ceph_flush_snaps()' directly.
>
> For #4 it will call 'ceph_flush_snaps()' by iterating the
> 'mdsc->snap_flush_list' list just before the #3 being triggered.
>
> The problem only exists in case of #1 --> #4, which will make the stale
> 'ci' to be held in the 'mdsc->snap_flush_list' list after 'capsnap' and
> 'ci' being freed. All the other cases are okay because the 'ci' will be
> protected by increasing the ref when allocating the 'capsnap' and will
> decrease the ref in 'handle_cap_flushsnap_ack()' when freeing the 'capsna=
p'.
>
> Note: the '__ceph_flush_snaps()' won't increase the ref. The
> 'handle_cap_flushsnap_ack()' will just try to decrease the ref and only
> in case the ref reaches to '0' will the 'ci' be freed.

So my question is: are all __ceph_flush_snaps() callers guaranteed to
hold an extra (i.e. one that is not tied to capsnap) reference on ci so
that when handle_cap_flushsnap_ack() drops one that is tied to capsnap
the reference count doesn't reach 0?  It sounds like you are confident
that there is no issue with ceph_flush_snaps() callers, but it would be
nice if you could confirm the same for bare __ceph_flush_snaps() call
sites in caps.c.

Thanks,

                Ilya
