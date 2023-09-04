Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97B17914BF
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Sep 2023 11:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjIDJaM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Sep 2023 05:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjIDJaM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Sep 2023 05:30:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D351CC
        for <ceph-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693819763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pduqvDsdTVAynA6CWqkWgKctoftPHqaoZnobLgRM3A=;
        b=Dsonv2rT3Vq3pudKbRHIWrTe+YChJ6RW/qvVBPoVJy/355n6vhWHJTSYfresMpftKtMPO4
        fsg/vt9vZyalpsDj/7xALWV0eBG0DIwqAK0rRF5GLe4nkiZ6MpfafCKBTce9oufT7O9CSx
        kJ7qpjVnzNweipaeE2OfTWNMeoaMp7I=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-kPFzzi4FPUS6jG2X1wRzhQ-1; Mon, 04 Sep 2023 05:29:22 -0400
X-MC-Unique: kPFzzi4FPUS6jG2X1wRzhQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso85432266b.3
        for <ceph-devel@vger.kernel.org>; Mon, 04 Sep 2023 02:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693819761; x=1694424561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pduqvDsdTVAynA6CWqkWgKctoftPHqaoZnobLgRM3A=;
        b=HOuJ6lv7yVfxWmgZVZc2SiWIo2HGGOABAvTNrP1xBWXRLSED/w5ziyMK7BZ/29fcw5
         OXKlkIMy7ueBy6m8fz3JJNVNqruJiMdTH+qLr2K4Do6qwtxeoUNtiMF34IRPfSaV6P4H
         yxcSw+FcnTtcbYoLmXmKidNjgF5o/FKtuP/7S3ZwZ18sbY70HYlmkryLnKexqNIAVmsu
         dP8QpO8M6CauR+N+Qug2gdGBYdKFHLCFk9wNIIO6WRM7KeMOiETVKKERrkTJ/u079lx9
         guDO/VqsgwrjSbAdrgz/dHfy6ZR+3q9WYEgYEzajuzh9VSJsH5BkQssnlVSTiVoN55VW
         61MQ==
X-Gm-Message-State: AOJu0YyXZhD9rNXQlU+kLr7s7TtZWgwky42EiH1tA4hy83K+ASOLi7Mk
        Bzrb8+WK2QJIV1RDTnBWZ9x+Y/YcUkzI/Qy9H+0qwSXDWwJTHLXBSIF6ofXi8U+kgSR6uBwtIzp
        owFOTDaAnkSkMtA7TWU2sP8UGwr69441FeXDczQ==
X-Received: by 2002:a17:906:74dd:b0:9a1:f9d7:90be with SMTP id z29-20020a17090674dd00b009a1f9d790bemr6901188ejl.18.1693819760527;
        Mon, 04 Sep 2023 02:29:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv8YliN75Glkw6bcZdHCrSrCP2OGOsOs7WwSukFodJONjhInILglMm76G6E9vSwD0AoFTFhmwWI/SP7cBwtO8=
X-Received: by 2002:a17:906:74dd:b0:9a1:f9d7:90be with SMTP id
 z29-20020a17090674dd00b009a1f9d790bemr6901169ejl.18.1693819760083; Mon, 04
 Sep 2023 02:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230619071438.7000-1-xiubli@redhat.com> <20230619071438.7000-4-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-4-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 4 Sep 2023 14:58:43 +0530
Message-ID: <CAED=hWByeeRqAo2JYdp1fAa_MPFHHWz2PtqKZQW376C6B8M-Fg@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] ceph: rename _to_client() to _to_fs_client()
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Tested-by: Milind Changire <mchangir@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>

On Mon, Jun 19, 2023 at 12:47=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> We need to covert the inode to ceph_client in the following commit,
> and will add one new helper for that, here we rename the old helper
> to _fs_client().
>
> URL: https://tracker.ceph.com/issues/61590
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c       | 20 ++++++++++----------
>  fs/ceph/cache.c      |  2 +-
>  fs/ceph/caps.c       | 40 ++++++++++++++++++++--------------------
>  fs/ceph/crypto.c     |  2 +-
>  fs/ceph/dir.c        | 22 +++++++++++-----------
>  fs/ceph/export.c     | 10 +++++-----
>  fs/ceph/file.c       | 24 ++++++++++++------------
>  fs/ceph/inode.c      | 14 +++++++-------
>  fs/ceph/ioctl.c      |  8 ++++----
>  fs/ceph/mds_client.c |  2 +-
>  fs/ceph/snap.c       |  2 +-
>  fs/ceph/super.c      | 22 +++++++++++-----------
>  fs/ceph/super.h      | 10 +++++-----
>  fs/ceph/xattr.c      | 12 ++++++------
>  14 files changed, 95 insertions(+), 95 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index de9b82905f18..e62318b3e13d 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -229,7 +229,7 @@ static void ceph_netfs_expand_readahead(struct netfs_=
io_request *rreq)
>  static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
>  {
>         struct inode *inode =3D subreq->rreq->inode;
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         u64 objno, objoff;
>         u32 xlen;
> @@ -244,7 +244,7 @@ static bool ceph_netfs_clamp_length(struct netfs_io_s=
ubrequest *subreq)
>  static void finish_netfs_read(struct ceph_osd_request *req)
>  {
>         struct inode *inode =3D req->r_inode;
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_data *osd_data =3D osd_req_op_extent_osd_data(req=
, 0);
>         struct netfs_io_subrequest *subreq =3D req->r_priv;
>         struct ceph_osd_req_op *op =3D &req->r_ops[0];
> @@ -347,7 +347,7 @@ static void ceph_netfs_issue_read(struct netfs_io_sub=
request *subreq)
>         struct netfs_io_request *rreq =3D subreq->rreq;
>         struct inode *inode =3D rreq->inode;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_request *req =3D NULL;
>         struct ceph_vino vino =3D ceph_vino(inode);
>         struct iov_iter iter;
> @@ -655,7 +655,7 @@ static int writepage_nounlock(struct page *page, stru=
ct writeback_control *wbc)
>         struct folio *folio =3D page_folio(page);
>         struct inode *inode =3D page->mapping->host;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_snap_context *snapc, *oldest;
>         loff_t page_off =3D page_offset(page);
>         int err;
> @@ -799,7 +799,7 @@ static int ceph_writepage(struct page *page, struct w=
riteback_control *wbc)
>         ihold(inode);
>
>         if (wbc->sync_mode =3D=3D WB_SYNC_NONE &&
> -           ceph_inode_to_client(inode)->write_congested)
> +           ceph_inode_to_fs_client(inode)->write_congested)
>                 return AOP_WRITEPAGE_ACTIVATE;
>
>         wait_on_page_fscache(page);
> @@ -832,7 +832,7 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
>         int rc =3D req->r_result;
>         struct ceph_snap_context *snapc =3D req->r_snapc;
>         struct address_space *mapping =3D inode->i_mapping;
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         unsigned int len =3D 0;
>         bool remove_page;
>
> @@ -922,7 +922,7 @@ static int ceph_writepages_start(struct address_space=
 *mapping,
>  {
>         struct inode *inode =3D mapping->host;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_vino vino =3D ceph_vino(inode);
>         pgoff_t index, start_index, end =3D -1;
>         struct ceph_snap_context *snapc =3D NULL, *last_snapc =3D NULL, *=
pgsnapc;
> @@ -1819,7 +1819,7 @@ int ceph_uninline_data(struct file *file)
>  {
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_request *req =3D NULL;
>         struct ceph_cap_flush *prealloc_cf =3D NULL;
>         struct folio *folio =3D NULL;
> @@ -1973,7 +1973,7 @@ enum {
>  static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
>                                 s64 pool, struct ceph_string *pool_ns)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(&ci->netfs.in=
ode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(&ci->netfs=
.inode);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct ceph_osd_request *rd_req =3D NULL, *wr_req =3D NULL;
>         struct rb_node **p, *parent;
> @@ -2164,7 +2164,7 @@ int ceph_pool_perm_check(struct inode *inode, int n=
eed)
>                 return 0;
>         }
>
> -       if (ceph_test_mount_opt(ceph_inode_to_client(inode),
> +       if (ceph_test_mount_opt(ceph_inode_to_fs_client(inode),
>                                 NOPOOLPERM))
>                 return 0;
>
> diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
> index 177d8e8d73fe..fedb8108c9f5 100644
> --- a/fs/ceph/cache.c
> +++ b/fs/ceph/cache.c
> @@ -15,7 +15,7 @@
>  void ceph_fscache_register_inode_cookie(struct inode *inode)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>
>         /* No caching for filesystem? */
>         if (!fsc->fscache)
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 99e805144935..4538c8280c70 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -635,7 +635,7 @@ void ceph_add_cap(struct inode *inode,
>                   unsigned seq, unsigned mseq, u64 realmino, int flags,
>                   struct ceph_cap **new_cap)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_cap *cap;
>         int mds =3D session->s_mds;
> @@ -922,7 +922,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *c=
i, int mask, int touch)
>  int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
>                                    int touch)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->netfs.inode.=
i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(ci->netfs.ino=
de.i_sb);
>         int r;
>
>         r =3D __ceph_caps_issued_mask(ci, mask, touch);
> @@ -996,7 +996,7 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *c=
i)
>         const int WR_SHIFT =3D ffs(CEPH_FILE_MODE_WR);
>         const int LAZY_SHIFT =3D ffs(CEPH_FILE_MODE_LAZY);
>         struct ceph_mount_options *opt =3D
> -               ceph_inode_to_client(&ci->netfs.inode)->mount_options;
> +               ceph_inode_to_fs_client(&ci->netfs.inode)->mount_options;
>         unsigned long used_cutoff =3D jiffies - opt->caps_wanted_delay_ma=
x * HZ;
>         unsigned long idle_cutoff =3D jiffies - opt->caps_wanted_delay_mi=
n * HZ;
>
> @@ -1121,7 +1121,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool q=
ueue_release)
>
>         dout("__ceph_remove_cap %p from %p\n", cap, &ci->netfs.inode);
>
> -       mdsc =3D ceph_inode_to_client(&ci->netfs.inode)->mdsc;
> +       mdsc =3D ceph_inode_to_fs_client(&ci->netfs.inode)->mdsc;
>
>         /* remove from inode's cap rbtree, and clear auth cap */
>         rb_erase(&cap->ci_node, &ci->i_caps);
> @@ -1192,7 +1192,7 @@ void ceph_remove_cap(struct ceph_mds_client *mdsc, =
struct ceph_cap *cap,
>
>         lockdep_assert_held(&ci->i_ceph_lock);
>
> -       fsc =3D ceph_inode_to_client(&ci->netfs.inode);
> +       fsc =3D ceph_inode_to_fs_client(&ci->netfs.inode);
>         WARN_ON_ONCE(ci->i_auth_cap =3D=3D cap &&
>                      !list_empty(&ci->i_dirty_item) &&
>                      !fsc->blocklisted &&
> @@ -1343,7 +1343,7 @@ static void encode_cap_msg(struct ceph_msg *msg, st=
ruct cap_msg_args *arg)
>  void __ceph_remove_caps(struct ceph_inode_info *ci)
>  {
>         struct inode *inode =3D &ci->netfs.inode;
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         struct rb_node *p;
>
>         /* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
> @@ -1685,7 +1685,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>                       struct ceph_mds_session **psession)
>  {
>         struct inode *inode =3D &ci->netfs.inode;
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         struct ceph_mds_session *session =3D NULL;
>         bool need_put =3D false;
>         int mds;
> @@ -1750,7 +1750,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *=
ci, int mask,
>                            struct ceph_cap_flush **pcf)
>  {
>         struct ceph_mds_client *mdsc =3D
> -               ceph_sb_to_client(ci->netfs.inode.i_sb)->mdsc;
> +               ceph_sb_to_fs_client(ci->netfs.inode.i_sb)->mdsc;
>         struct inode *inode =3D &ci->netfs.inode;
>         int was =3D ci->i_dirty_caps;
>         int dirty =3D 0;
> @@ -1873,7 +1873,7 @@ static u64 __mark_caps_flushing(struct inode *inode=
,
>                                 struct ceph_mds_session *session, bool wa=
ke,
>                                 u64 *oldest_flush_tid)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_cap_flush *cf =3D NULL;
>         int flushing;
> @@ -2233,7 +2233,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, in=
t flags)
>   */
>  static int try_flush_caps(struct inode *inode, u64 *ptid)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         int flushing =3D 0;
>         u64 flush_tid =3D 0, oldest_flush_tid =3D 0;
> @@ -2311,7 +2311,7 @@ static int caps_are_flushed(struct inode *inode, u6=
4 flush_tid)
>   */
>  static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inod=
e)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_mds_request *req1 =3D NULL, *req2 =3D NULL;
>         int ret, err =3D 0;
> @@ -2494,7 +2494,7 @@ int ceph_write_inode(struct inode *inode, struct wr=
iteback_control *wbc)
>                                        caps_are_flushed(inode, flush_tid)=
);
>         } else {
>                 struct ceph_mds_client *mdsc =3D
> -                       ceph_sb_to_client(inode->i_sb)->mdsc;
> +                       ceph_sb_to_fs_client(inode->i_sb)->mdsc;
>
>                 spin_lock(&ci->i_ceph_lock);
>                 if (__ceph_caps_dirty(ci))
> @@ -2747,7 +2747,7 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
>                             loff_t endoff, int flags, int *got)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         int ret =3D 0;
>         int have, implemented;
>         bool snap_rwsem_locked =3D false;
> @@ -2965,7 +2965,7 @@ int __ceph_get_caps(struct inode *inode, struct cep=
h_file_info *fi, int need,
>                     int want, loff_t endoff, int *got)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         int ret, _got, flags;
>
>         ret =3D ceph_pool_perm_check(inode, need);
> @@ -3717,7 +3717,7 @@ static void handle_cap_flush_ack(struct inode *inod=
e, u64 flush_tid,
>         __releases(ci->i_ceph_lock)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_cap_flush *cf, *tmp_cf;
>         LIST_HEAD(to_remove);
>         unsigned seq =3D le32_to_cpu(m->seq);
> @@ -3827,7 +3827,7 @@ void __ceph_remove_capsnap(struct inode *inode, str=
uct ceph_cap_snap *capsnap,
>                            bool *wake_ci, bool *wake_mdsc)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         bool ret;
>
>         lockdep_assert_held(&ci->i_ceph_lock);
> @@ -3871,7 +3871,7 @@ static void handle_cap_flushsnap_ack(struct inode *=
inode, u64 flush_tid,
>                                      struct ceph_mds_session *session)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         u64 follows =3D le64_to_cpu(m->snap_follows);
>         struct ceph_cap_snap *capsnap =3D NULL, *iter;
>         bool wake_ci =3D false;
> @@ -3964,7 +3964,7 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
>                               struct ceph_mds_cap_peer *ph,
>                               struct ceph_mds_session *session)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         struct ceph_mds_session *tsession =3D NULL;
>         struct ceph_cap *cap, *tcap, *new_cap =3D NULL;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> @@ -4672,7 +4672,7 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
>
>                 if (__ceph_caps_dirty(ci)) {
>                         struct ceph_mds_client *mdsc =3D
> -                               ceph_inode_to_client(inode)->mdsc;
> +                               ceph_inode_to_fs_client(inode)->mdsc;
>                         __cap_delay_requeue_front(mdsc, ci);
>                 }
>         }
> @@ -4855,7 +4855,7 @@ static int remove_capsnaps(struct ceph_mds_client *=
mdsc, struct inode *inode)
>
>  int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool=
 *invalidate)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         bool is_auth;
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index e72bab29d5e1..4b0e9c3a53c8 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -128,7 +128,7 @@ static bool ceph_crypt_empty_dir(struct inode *inode)
>
>  static const union fscrypt_policy *ceph_get_dummy_policy(struct super_bl=
ock *sb)
>  {
> -       return ceph_sb_to_client(sb)->fsc_dummy_enc_policy.policy;
> +       return ceph_sb_to_fs_client(sb)->fsc_dummy_enc_policy.policy;
>  }
>
>  static struct fscrypt_operations ceph_fscrypt_ops =3D {
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5fbcd0d5e5ec..69906b721992 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -310,7 +310,7 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
>         struct ceph_dir_file_info *dfi =3D file->private_data;
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         int i;
>         int err;
> @@ -702,7 +702,7 @@ static loff_t ceph_dir_llseek(struct file *file, loff=
_t offset, int whence)
>  struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
>                                    struct dentry *dentry)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dentry->d_sb)=
;
>         struct inode *parent =3D d_inode(dentry->d_parent); /* we hold i_=
rwsem */
>
>         /* .snap dir? */
> @@ -770,7 +770,7 @@ static bool is_root_ceph_dentry(struct inode *inode, =
struct dentry *dentry)
>  static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dent=
ry,
>                                   unsigned int flags)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dir->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dir->i_sb);
>         struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(dir->i_sb);
>         struct ceph_mds_request *req;
>         int op;
> @@ -1192,7 +1192,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_cl=
ient *mdsc,
>                                  struct ceph_mds_request *req)
>  {
>         struct dentry *dentry =3D req->r_dentry;
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dentry->d_sb)=
;
>         struct ceph_dentry_info *di =3D ceph_dentry(dentry);
>         int result =3D req->r_err ? req->r_err :
>                         le32_to_cpu(req->r_reply_info.head->result);
> @@ -1283,7 +1283,7 @@ static int get_caps_for_async_unlink(struct inode *=
dir, struct dentry *dentry)
>   */
>  static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dir->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dir->i_sb);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct inode *inode =3D d_inode(dentry);
>         struct ceph_mds_request *req;
> @@ -1461,7 +1461,7 @@ void __ceph_dentry_lease_touch(struct ceph_dentry_i=
nfo *di)
>                 return;
>         }
>
> -       mdsc =3D ceph_sb_to_client(dn->d_sb)->mdsc;
> +       mdsc =3D ceph_sb_to_fs_client(dn->d_sb)->mdsc;
>         spin_lock(&mdsc->dentry_list_lock);
>         list_move_tail(&di->lease_list, &mdsc->dentry_leases);
>         spin_unlock(&mdsc->dentry_list_lock);
> @@ -1508,7 +1508,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_dent=
ry_info *di)
>                 return;
>         }
>
> -       mdsc =3D ceph_sb_to_client(dn->d_sb)->mdsc;
> +       mdsc =3D ceph_sb_to_fs_client(dn->d_sb)->mdsc;
>         spin_lock(&mdsc->dentry_list_lock);
>         __dentry_dir_lease_touch(mdsc, di),
>         spin_unlock(&mdsc->dentry_list_lock);
> @@ -1522,7 +1522,7 @@ static void __dentry_lease_unlist(struct ceph_dentr=
y_info *di)
>         if (list_empty(&di->lease_list))
>                 return;
>
> -       mdsc =3D ceph_sb_to_client(di->dentry->d_sb)->mdsc;
> +       mdsc =3D ceph_sb_to_fs_client(di->dentry->d_sb)->mdsc;
>         spin_lock(&mdsc->dentry_list_lock);
>         list_del_init(&di->lease_list);
>         spin_unlock(&mdsc->dentry_list_lock);
> @@ -1879,7 +1879,7 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
>         dout("d_revalidate %p '%pd' inode %p offset 0x%llx nokey %d\n", d=
entry,
>              dentry, inode, ceph_dentry(dentry)->offset, !!(dentry->d_fla=
gs & DCACHE_NOKEY_NAME));
>
> -       mdsc =3D ceph_sb_to_client(dir->i_sb)->mdsc;
> +       mdsc =3D ceph_sb_to_fs_client(dir->i_sb)->mdsc;
>
>         /* always trust cached snapped dentries, snapdir dentry */
>         if (ceph_snap(dir) !=3D CEPH_NOSNAP) {
> @@ -1986,7 +1986,7 @@ static int ceph_d_delete(const struct dentry *dentr=
y)
>  static void ceph_d_release(struct dentry *dentry)
>  {
>         struct ceph_dentry_info *di =3D ceph_dentry(dentry);
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dentry->d_sb)=
;
>
>         dout("d_release %p\n", dentry);
>
> @@ -2055,7 +2055,7 @@ static ssize_t ceph_read_dir(struct file *file, cha=
r __user *buf, size_t size,
>         int left;
>         const int bufsize =3D 1024;
>
> -       if (!ceph_test_mount_opt(ceph_sb_to_client(inode->i_sb), DIRSTAT)=
)
> +       if (!ceph_test_mount_opt(ceph_sb_to_fs_client(inode->i_sb), DIRST=
AT))
>                 return -EISDIR;
>
>         if (!dfi->dir_info) {
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 8559990a59a5..52c4daf2447d 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -123,7 +123,7 @@ static int ceph_encode_fh(struct inode *inode, u32 *r=
awfh, int *max_len,
>
>  static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(sb)->mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(sb)->mdsc;
>         struct inode *inode;
>         struct ceph_vino vino;
>         int err;
> @@ -205,7 +205,7 @@ static struct dentry *__snapfh_to_dentry(struct super=
_block *sb,
>                                           struct ceph_nfs_snapfh *sfh,
>                                           bool want_parent)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(sb)->mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(sb)->mdsc;
>         struct ceph_mds_request *req;
>         struct inode *inode;
>         struct ceph_vino vino;
> @@ -317,7 +317,7 @@ static struct dentry *ceph_fh_to_dentry(struct super_=
block *sb,
>  static struct dentry *__get_parent(struct super_block *sb,
>                                    struct dentry *child, u64 ino)
>  {
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(sb)->mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(sb)->mdsc;
>         struct ceph_mds_request *req;
>         struct inode *inode;
>         int mask;
> @@ -439,7 +439,7 @@ static int __get_snap_name(struct dentry *parent, cha=
r *name,
>  {
>         struct inode *inode =3D d_inode(child);
>         struct inode *dir =3D d_inode(parent);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_mds_request *req =3D NULL;
>         char *last_name =3D NULL;
>         unsigned next_offset =3D 2;
> @@ -544,7 +544,7 @@ static int ceph_get_name(struct dentry *parent, char =
*name,
>         if (ceph_snap(inode) !=3D CEPH_NOSNAP)
>                 return __get_snap_name(parent, name, child);
>
> -       mdsc =3D ceph_inode_to_client(inode)->mdsc;
> +       mdsc =3D ceph_inode_to_fs_client(inode)->mdsc;
>         req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
>                                        USE_ANY_MDS);
>         if (IS_ERR(req))
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 04bc4cc8ad9b..344f0b6260bd 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -200,7 +200,7 @@ static int ceph_init_file_info(struct inode *inode, s=
truct file *file,
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_mount_options *opt =3D
> -               ceph_inode_to_client(&ci->netfs.inode)->mount_options;
> +               ceph_inode_to_fs_client(&ci->netfs.inode)->mount_options;
>         struct ceph_file_info *fi;
>         int ret;
>
> @@ -234,7 +234,7 @@ static int ceph_init_file_info(struct inode *inode, s=
truct file *file,
>
>         spin_lock_init(&fi->rw_contexts_lock);
>         INIT_LIST_HEAD(&fi->rw_contexts);
> -       fi->filp_gen =3D READ_ONCE(ceph_inode_to_client(inode)->filp_gen)=
;
> +       fi->filp_gen =3D READ_ONCE(ceph_inode_to_fs_client(inode)->filp_g=
en);
>
>         if ((file->f_mode & FMODE_WRITE) && ceph_has_inline_data(ci)) {
>                 ret =3D ceph_uninline_data(file);
> @@ -352,7 +352,7 @@ int ceph_renew_caps(struct inode *inode, int fmode)
>  int ceph_open(struct inode *inode, struct file *file)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(inode->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(inode->i_sb);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct ceph_mds_request *req;
>         struct ceph_file_info *fi =3D file->private_data;
> @@ -730,7 +730,7 @@ static int ceph_finish_async_create(struct inode *dir=
, struct inode *inode,
>  int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>                      struct file *file, unsigned flags, umode_t mode)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dir->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dir->i_sb);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct ceph_mds_request *req;
>         struct inode *new_inode =3D NULL;
> @@ -959,7 +959,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t =
*ki_pos,
>                          u64 *last_objver)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>         ssize_t ret;
>         u64 off =3D *ki_pos;
> @@ -1252,7 +1252,7 @@ static void ceph_aio_complete_req(struct ceph_osd_r=
equest *req)
>                 if (aio_work) {
>                         INIT_WORK(&aio_work->work, ceph_aio_retry_work);
>                         aio_work->req =3D req;
> -                       queue_work(ceph_inode_to_client(inode)->inode_wq,
> +                       queue_work(ceph_inode_to_fs_client(inode)->inode_=
wq,
>                                    &aio_work->work);
>                         return;
>                 }
> @@ -1382,7 +1382,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
>         struct file *file =3D iocb->ki_filp;
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
>         struct ceph_vino vino;
>         struct ceph_osd_request *req;
> @@ -1606,7 +1606,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter=
 *from, loff_t pos,
>         struct file *file =3D iocb->ki_filp;
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>         struct ceph_osd_request *req;
>         struct page **pages;
> @@ -2159,7 +2159,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
>         struct ceph_file_info *fi =3D file->private_data;
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>         struct ceph_cap_flush *prealloc_cf;
>         ssize_t count, written =3D 0;
> @@ -2399,7 +2399,7 @@ static int ceph_zero_partial_object(struct inode *i=
node,
>                                     loff_t offset, loff_t *length)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_osd_request *req;
>         int ret =3D 0;
>         loff_t zero =3D 0;
> @@ -2782,7 +2782,7 @@ static ssize_t __ceph_copy_file_range(struct file *=
src_file, loff_t src_off,
>         struct ceph_inode_info *src_ci =3D ceph_inode(src_inode);
>         struct ceph_inode_info *dst_ci =3D ceph_inode(dst_inode);
>         struct ceph_cap_flush *prealloc_cf;
> -       struct ceph_fs_client *src_fsc =3D ceph_inode_to_client(src_inode=
);
> +       struct ceph_fs_client *src_fsc =3D ceph_inode_to_fs_client(src_in=
ode);
>         loff_t size;
>         ssize_t ret =3D -EIO, bytes;
>         u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
> @@ -2790,7 +2790,7 @@ static ssize_t __ceph_copy_file_range(struct file *=
src_file, loff_t src_off,
>         int src_got =3D 0, dst_got =3D 0, err, dirty;
>
>         if (src_inode->i_sb !=3D dst_inode->i_sb) {
> -               struct ceph_fs_client *dst_fsc =3D ceph_inode_to_client(d=
st_inode);
> +               struct ceph_fs_client *dst_fsc =3D ceph_inode_to_fs_clien=
t(dst_inode);
>
>                 if (ceph_fsid_compare(&src_fsc->client->fsid,
>                                       &dst_fsc->client->fsid)) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index fe8adb9d67a6..c283ea632c51 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1497,7 +1497,7 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>         struct ceph_mds_reply_info_parsed *rinfo =3D &req->r_reply_info;
>         struct inode *in =3D NULL;
>         struct ceph_vino tvino, dvino;
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>         int err =3D 0;
>
>         dout("fill_trace %p is_dentry %d is_target %d\n", req,
> @@ -2087,7 +2087,7 @@ bool ceph_inode_set_size(struct inode *inode, loff_=
t size)
>
>  void ceph_queue_inode_work(struct inode *inode, int work_bit)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         set_bit(work_bit, &ci->i_work_mask);
>
> @@ -2429,7 +2429,7 @@ int __ceph_setattr(struct inode *inode, struct iatt=
r *attr, struct ceph_iattr *c
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         unsigned int ia_valid =3D attr->ia_valid;
>         struct ceph_mds_request *req;
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_cap_flush *prealloc_cf;
>         loff_t isize =3D i_size_read(inode);
>         int issued;
> @@ -2741,7 +2741,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct de=
ntry *dentry,
>                  struct iattr *attr)
>  {
>         struct inode *inode =3D d_inode(dentry);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         int err;
>
>         if (ceph_snap(inode) !=3D CEPH_NOSNAP)
> @@ -2811,7 +2811,7 @@ int ceph_try_to_choose_auth_mds(struct inode *inode=
, int mask)
>  int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>                       int mask, bool force)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(inode->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(inode->i_sb);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct ceph_mds_request *req;
>         int mode;
> @@ -2857,7 +2857,7 @@ int __ceph_do_getattr(struct inode *inode, struct p=
age *locked_page,
>  int ceph_do_getvxattr(struct inode *inode, const char *name, void *value=
,
>                       size_t size)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(inode->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(inode->i_sb);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         struct ceph_mds_request *req;
>         int mode =3D USE_AUTH_MDS;
> @@ -3002,7 +3002,7 @@ int ceph_getattr(struct mnt_idmap *idmap, const str=
uct path *path,
>                 stat->dev =3D ci->i_snapid_map ? ci->i_snapid_map->dev : =
0;
>
>         if (S_ISDIR(inode->i_mode)) {
> -               if (ceph_test_mount_opt(ceph_sb_to_client(sb), RBYTES)) {
> +               if (ceph_test_mount_opt(ceph_sb_to_fs_client(sb), RBYTES)=
) {
>                         stat->size =3D ci->i_rbytes;
>                 } else if (ceph_snap(inode) =3D=3D CEPH_SNAPDIR) {
>                         struct ceph_inode_info *pci;
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 679402bd80ba..64d8e34d9f7e 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -65,7 +65,7 @@ static long __validate_layout(struct ceph_mds_client *m=
dsc,
>  static long ceph_ioctl_set_layout(struct file *file, void __user *arg)
>  {
>         struct inode *inode =3D file_inode(file);
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_mds_request *req;
>         struct ceph_ioctl_layout l;
>         struct ceph_inode_info *ci =3D ceph_inode(file_inode(file));
> @@ -140,7 +140,7 @@ static long ceph_ioctl_set_layout_policy (struct file=
 *file, void __user *arg)
>         struct ceph_mds_request *req;
>         struct ceph_ioctl_layout l;
>         int err;
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>
>         /* copy and validate */
>         if (copy_from_user(&l, arg, sizeof(l)))
> @@ -183,7 +183,7 @@ static long ceph_ioctl_get_dataloc(struct file *file,=
 void __user *arg)
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_osd_client *osdc =3D
> -               &ceph_sb_to_client(inode->i_sb)->client->osdc;
> +               &ceph_sb_to_fs_client(inode->i_sb)->client->osdc;
>         struct ceph_object_locator oloc;
>         CEPH_DEFINE_OID_ONSTACK(oid);
>         u32 xlen;
> @@ -244,7 +244,7 @@ static long ceph_ioctl_lazyio(struct file *file)
>         struct ceph_file_info *fi =3D file->private_data;
>         struct inode *inode =3D file_inode(file);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>
>         if ((fi->fmode & CEPH_FILE_MODE_LAZY) =3D=3D 0) {
>                 spin_lock(&ci->i_ceph_lock);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index b9c7b6c60357..a730bd98a4d2 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -829,7 +829,7 @@ static void destroy_reply_info(struct ceph_mds_reply_=
info_parsed *info)
>   */
>  int ceph_wait_on_conflict_unlink(struct dentry *dentry)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(dentry->d_sb)=
;
>         struct dentry *pdentry =3D dentry->d_parent;
>         struct dentry *udentry, *found =3D NULL;
>         struct ceph_dentry_info *di;
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 5bd47829a005..09939ec0d1ee 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -963,7 +963,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
>  void ceph_change_snap_realm(struct inode *inode, struct ceph_snap_realm =
*realm)
>  {
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         struct ceph_snap_realm *oldrealm =3D ci->i_snap_realm;
>
>         lockdep_assert_held(&ci->i_ceph_lock);
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 070b3150d267..e0c9ed100767 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -44,7 +44,7 @@ static LIST_HEAD(ceph_fsc_list);
>   */
>  static void ceph_put_super(struct super_block *s)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(s);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(s);
>
>         dout("put_super\n");
>         ceph_fscrypt_free_dummy_policy(fsc);
> @@ -53,7 +53,7 @@ static void ceph_put_super(struct super_block *s)
>
>  static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(d_inode(dentr=
y));
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(d_inode(de=
ntry));
>         struct ceph_mon_client *monc =3D &fsc->client->monc;
>         struct ceph_statfs st;
>         int i, err;
> @@ -118,7 +118,7 @@ static int ceph_statfs(struct dentry *dentry, struct =
kstatfs *buf)
>
>  static int ceph_sync_fs(struct super_block *sb, int wait)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>
>         if (!wait) {
>                 dout("sync_fs (non-blocking)\n");
> @@ -695,7 +695,7 @@ static int compare_mount_options(struct ceph_mount_op=
tions *new_fsopt,
>   */
>  static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(root->d_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(root->d_sb);
>         struct ceph_mount_options *fsopt =3D fsc->mount_options;
>         size_t pos;
>         int ret;
> @@ -1026,7 +1026,7 @@ static void __ceph_umount_begin(struct ceph_fs_clie=
nt *fsc)
>   */
>  void ceph_umount_begin(struct super_block *sb)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>
>         dout("ceph_umount_begin - starting forced umount\n");
>         if (!fsc)
> @@ -1236,7 +1236,7 @@ static int ceph_compare_super(struct super_block *s=
b, struct fs_context *fc)
>         struct ceph_fs_client *new =3D fc->s_fs_info;
>         struct ceph_mount_options *fsopt =3D new->mount_options;
>         struct ceph_options *opt =3D new->client->options;
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>
>         dout("ceph_compare_super %p\n", sb);
>
> @@ -1332,9 +1332,9 @@ static int ceph_get_tree(struct fs_context *fc)
>                 goto out;
>         }
>
> -       if (ceph_sb_to_client(sb) !=3D fsc) {
> +       if (ceph_sb_to_fs_client(sb) !=3D fsc) {
>                 destroy_fs_client(fsc);
> -               fsc =3D ceph_sb_to_client(sb);
> +               fsc =3D ceph_sb_to_fs_client(sb);
>                 dout("get_sb got existing client %p\n", fsc);
>         } else {
>                 dout("get_sb using new client %p\n", fsc);
> @@ -1387,7 +1387,7 @@ static int ceph_reconfigure_fc(struct fs_context *f=
c)
>         struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
>         struct ceph_mount_options *fsopt =3D pctx->opts;
>         struct super_block *sb =3D fc->root->d_sb;
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>
>         err =3D ceph_apply_test_dummy_encryption(sb, fc, fsopt);
>         if (err)
> @@ -1526,7 +1526,7 @@ void ceph_dec_osd_stopping_blocker(struct ceph_mds_=
client *mdsc)
>
>  static void ceph_kill_sb(struct super_block *s)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(s);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(s);
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
>         bool wait;
>
> @@ -1587,7 +1587,7 @@ MODULE_ALIAS_FS("ceph");
>
>  int ceph_force_reconnect(struct super_block *sb)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>         int err =3D 0;
>
>         fsc->mount_state =3D CEPH_MOUNT_RECOVER;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ab5c0c703eae..9655ea46e6ca 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -490,13 +490,13 @@ ceph_inode(const struct inode *inode)
>  }
>
>  static inline struct ceph_fs_client *
> -ceph_inode_to_client(const struct inode *inode)
> +ceph_inode_to_fs_client(const struct inode *inode)
>  {
>         return (struct ceph_fs_client *)inode->i_sb->s_fs_info;
>  }
>
>  static inline struct ceph_fs_client *
> -ceph_sb_to_client(const struct super_block *sb)
> +ceph_sb_to_fs_client(const struct super_block *sb)
>  {
>         return (struct ceph_fs_client *)sb->s_fs_info;
>  }
> @@ -504,7 +504,7 @@ ceph_sb_to_client(const struct super_block *sb)
>  static inline struct ceph_mds_client *
>  ceph_sb_to_mdsc(const struct super_block *sb)
>  {
> -       return (struct ceph_mds_client *)ceph_sb_to_client(sb)->mdsc;
> +       return (struct ceph_mds_client *)ceph_sb_to_fs_client(sb)->mdsc;
>  }
>
>  static inline struct ceph_vino
> @@ -560,7 +560,7 @@ static inline u64 ceph_snap(struct inode *inode)
>   */
>  static inline u64 ceph_present_ino(struct super_block *sb, u64 ino)
>  {
> -       if (unlikely(ceph_test_mount_opt(ceph_sb_to_client(sb), INO32)))
> +       if (unlikely(ceph_test_mount_opt(ceph_sb_to_fs_client(sb), INO32)=
))
>                 return ceph_ino_to_ino32(ino);
>         return ino;
>  }
> @@ -1106,7 +1106,7 @@ void ceph_inode_shutdown(struct inode *inode);
>  static inline bool ceph_inode_is_shutdown(struct inode *inode)
>  {
>         unsigned long flags =3D READ_ONCE(ceph_inode(inode)->i_ceph_flags=
);
> -       struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> +       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         int state =3D READ_ONCE(fsc->mount_state);
>
>         return (flags & CEPH_I_SHUTDOWN) || state >=3D CEPH_MOUNT_SHUTDOW=
N;
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 76680e5c2f82..e30ae1032e13 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -57,7 +57,7 @@ static bool ceph_vxattrcb_layout_exists(struct ceph_ino=
de_info *ci)
>  static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *va=
l,
>                                     size_t size)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->netfs.inode.=
i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(ci->netfs.ino=
de.i_sb);
>         struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>         struct ceph_string *pool_ns;
>         s64 pool =3D ci->i_layout.pool_id;
> @@ -161,7 +161,7 @@ static ssize_t ceph_vxattrcb_layout_pool(struct ceph_=
inode_info *ci,
>                                          char *val, size_t size)
>  {
>         ssize_t ret;
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->netfs.inode.=
i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(ci->netfs.ino=
de.i_sb);
>         struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>         s64 pool =3D ci->i_layout.pool_id;
>         const char *pool_name;
> @@ -313,7 +313,7 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_i=
node_info *ci, char *val,
>  static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
>                                           char *val, size_t size)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->netfs.inode.=
i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(ci->netfs.ino=
de.i_sb);
>
>         return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
>  }
> @@ -321,7 +321,7 @@ static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph=
_inode_info *ci,
>  static ssize_t ceph_vxattrcb_client_id(struct ceph_inode_info *ci,
>                                        char *val, size_t size)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->netfs.inode.=
i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(ci->netfs.ino=
de.i_sb);
>
>         return ceph_fmt_xattr(val, size, "client%lld",
>                               ceph_client_gid(fsc->client));
> @@ -1093,7 +1093,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char =
*names, size_t size)
>  static int ceph_sync_setxattr(struct inode *inode, const char *name,
>                               const char *value, size_t size, int flags)
>  {
> -       struct ceph_fs_client *fsc =3D ceph_sb_to_client(inode->i_sb);
> +       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(inode->i_sb);
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_mds_request *req;
>         struct ceph_mds_client *mdsc =3D fsc->mdsc;
> @@ -1163,7 +1163,7 @@ int __ceph_setxattr(struct inode *inode, const char=
 *name,
>  {
>         struct ceph_vxattr *vxattr;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
> -       struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->=
mdsc;
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>         struct ceph_cap_flush *prealloc_cf =3D NULL;
>         struct ceph_buffer *old_blob =3D NULL;
>         int issued;
> --
> 2.40.1
>


--=20
Milind

