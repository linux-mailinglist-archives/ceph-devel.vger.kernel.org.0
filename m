Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0651D0F5
	for <lists+ceph-devel@lfdr.de>; Tue, 14 May 2019 23:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfENVAp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 May 2019 17:00:45 -0400
Received: from hr2.samba.org ([144.76.82.148]:43564 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfENVAo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 May 2019 17:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=G0EhzXZhJW3J9pOqL3UN+wXs+KA6RWhXRFmnIHZOLwI=; b=XPUXDw6jmgNWvUxlwf2XpB26td
        Q8EVHgHbWbFBGGSac9HTpZJNyEo7FhtSZM0lcJd8ToDx/iA3iJP2mV26x32DHhbrD/FX1kiZA2nNh
        92flN+6L5XjS6VQZEuIO11oxbmExdxq1mfe3S3MN/cbEhnwA+xrb+PC1I4QEV+fFQ93k=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hQeXJ-0003s6-VJ; Tue, 14 May 2019 21:00:35 +0000
Date:   Tue, 14 May 2019 14:00:30 -0700
From:   Jeremy Allison <jra@samba.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     Jeremy Allison via samba-technical 
        <samba-technical@lists.samba.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        jra@samba.org
Subject: Re: [PATCH] Samba: CephFS Snapshots VFS module
Message-ID: <20190514210030.GE210466@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20190329184531.0c78e06b@echidna.suse.de>
 <20190508224740.GA21367@jra4>
 <20190510151601.798bee61@suse.de>
 <20190510185841.GA54524@jra4>
 <20190513122738.78b2b566@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20190513122738.78b2b566@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2019 at 12:27:38PM +0200, David Disseldorp wrote:
> 
> I really wish we didn't use errno across the VFS interface :-)
> New saved_errno version attached...

Thanks. The VFS interface was originally intended to be like
the POSIX one, which is why the use of errno bled though :-(.

I think ultimately we need to move it to an all NT_STATUS
return interface, and return parameters as pointers, but
that's a patch for another day.

Your patchset LGTM, with a few changes I needed to make
to get it past my compiler.

Attached is a diff of the changes I had to make to
patch #2 of the series so you can review my changes,
and the second attachment is the rebases patchset
containing my changes.

Mostly it's just removing unused variables and fixing
up strict printf format string restrictions, but you
might want to look at the change I did below, to split
out the if conditions into more easily understandable
(for me at least) logic using a helper bool variable.

        /* for absolute paths, check that we're not going outside the share */
        if ((len > 0) && (_parent_buf[0] == '/')) {
+               bool connectpath_match = false;
                size_t clen = strlen(connectpath);
                DBG_DEBUG("checking absolute path %s lies within share at %s\n",
                          _parent_buf, connectpath);
                /* need to check for separator, to avoid /x/abcd vs /x/ab */
-               if (strncmp(connectpath, _parent_buf, clen)
-                || (_parent_buf[clen] != '/') && (_parent_buf[clen] != '\0')) {
+               connectpath_match = (strncmp(connectpath,
+                                       _parent_buf,
+                                       clen) == 0);
+               if (!connectpath_match
+                || ((_parent_buf[clen] != '/') && (_parent_buf[clen] != '\0'))) {


If you're happy, please push ! Thanks for your patience
with the review, sorry it's been a bit of a struggle (but
as I said I *really* want this change :-).

Cheers,

	Jeremy.

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vfs_ceph_snapshots_v3.fixes"

diff --git a/source3/modules/vfs_ceph_snapshots.c b/source3/modules/vfs_ceph_snapshots.c
index 7acb4874a15..4183069a5c2 100644
--- a/source3/modules/vfs_ceph_snapshots.c
+++ b/source3/modules/vfs_ceph_snapshots.c
@@ -131,7 +131,6 @@ static int ceph_snap_fill_label(struct vfs_handle_struct *handle,
 	struct tm *tm_ret;
 	size_t str_sz;
 	char snap_path[PATH_MAX + 1];
-	struct timespec snap_timespec;
 	int ret;
 
 	/*
@@ -217,8 +216,6 @@ static int ceph_snap_enum_snapdir(struct vfs_handle_struct *handle,
 	for (e = SMB_VFS_NEXT_READDIR(handle, d, NULL);
 	     e != NULL;
 	     e = SMB_VFS_NEXT_READDIR(handle, d, NULL)) {
-		char *this_label;
-
 		if (ISDOT(e->d_name) || ISDOTDOT(e->d_name)) {
 			continue;
 		}
@@ -313,19 +310,23 @@ static int ceph_snap_get_parent_path(const char *connectpath,
 	SMB_ASSERT(p >= path);
 	len = p - path;
 
-	ret = snprintf(_parent_buf, buflen, "%.*s", len, path);
+	ret = snprintf(_parent_buf, buflen, "%.*s", (int)len, path);
 	if (ret >= buflen) {
 		return -EINVAL;
 	}
 
 	/* for absolute paths, check that we're not going outside the share */
 	if ((len > 0) && (_parent_buf[0] == '/')) {
+		bool connectpath_match = false;
 		size_t clen = strlen(connectpath);
 		DBG_DEBUG("checking absolute path %s lies within share at %s\n",
 			  _parent_buf, connectpath);
 		/* need to check for separator, to avoid /x/abcd vs /x/ab */
-		if (strncmp(connectpath, _parent_buf, clen)
-		 || (_parent_buf[clen] != '/') && (_parent_buf[clen] != '\0')) {
+		connectpath_match = (strncmp(connectpath,
+					_parent_buf,
+					clen) == 0);
+		if (!connectpath_match
+		 || ((_parent_buf[clen] != '/') && (_parent_buf[clen] != '\0'))) {
 			DBG_ERR("%s parent path is outside of share at %s\n",
 				_parent_buf, connectpath);
 			return -EINVAL;
@@ -430,7 +431,6 @@ static bool ceph_snap_gmt_strip_snapshot(struct vfs_handle_struct *handle,
 	time_t timestamp;
 	const char *p;
 	char *q;
-	char *stripped;
 	size_t rest_len, dst_len;
 	ptrdiff_t len_before_gmt;
 
@@ -612,21 +612,22 @@ static int ceph_snap_gmt_convert_dir(struct vfs_handle_struct *handle,
 		if (timestamp == snap_secs) {
 			break;
 		}
-		DBG_DEBUG("[connectpath %s] %s@%d no match for snap %s@%d\n",
-			  handle->conn->connectpath, name, timestamp,
-			  e->d_name, snap_secs);
+		DBG_DEBUG("[connectpath %s] %s@%lld no match for snap %s@%lld\n",
+			  handle->conn->connectpath, name, (long long)timestamp,
+			  e->d_name, (long long)snap_secs);
 	}
 
 	if (e == NULL) {
-		DBG_INFO("[connectpath %s] failed to find %s @ time %d\n",
-			 handle->conn->connectpath, name, timestamp);
+		DBG_INFO("[connectpath %s] failed to find %s @ time %lld\n",
+			 handle->conn->connectpath, name, (long long)timestamp);
 		ret = -ENOENT;
 		goto err_closedir;
 	}
 
 	/* found, _converted_buf already contains path of interest */
-	DBG_DEBUG("[connectpath %s] converted %s @ time %d to %s\n",
-		  handle->conn->connectpath, name, timestamp, _converted_buf);
+	DBG_DEBUG("[connectpath %s] converted %s @ time %lld to %s\n",
+		  handle->conn->connectpath, name, (long long)timestamp,
+		  _converted_buf);
 
 	ret = SMB_VFS_NEXT_CLOSEDIR(handle, d);
 	if (ret != 0) {
@@ -958,7 +959,6 @@ static int ceph_snap_gmt_unlink(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1001,7 +1001,6 @@ static int ceph_snap_gmt_chmod(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1045,7 +1044,6 @@ static int ceph_snap_gmt_chown(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1087,7 +1085,6 @@ static int ceph_snap_gmt_chdir(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1130,7 +1127,6 @@ static int ceph_snap_gmt_ntimes(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1174,7 +1170,6 @@ static int ceph_snap_gmt_readlink(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1217,7 +1212,6 @@ static int ceph_snap_gmt_mknod(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1259,7 +1253,6 @@ static struct smb_filename *ceph_snap_gmt_realpath(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	struct smb_filename *result_fname;
 	int ret;
 	struct smb_filename *new_fname;
@@ -1309,7 +1302,6 @@ static NTSTATUS ceph_snap_gmt_fget_nt_acl(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	struct smb_filename *smb_fname;
 	int ret;
 	NTSTATUS status;
@@ -1355,7 +1347,6 @@ static NTSTATUS ceph_snap_gmt_get_nt_acl(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	NTSTATUS status;
 	struct smb_filename *new_fname;
@@ -1397,7 +1388,6 @@ static int ceph_snap_gmt_mkdir(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1438,7 +1428,6 @@ static int ceph_snap_gmt_rmdir(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1480,7 +1469,6 @@ static int ceph_snap_gmt_chflags(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1524,7 +1512,6 @@ static ssize_t ceph_snap_gmt_getxattr(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1567,7 +1554,6 @@ static ssize_t ceph_snap_gmt_listxattr(struct vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1609,7 +1595,6 @@ static int ceph_snap_gmt_removexattr(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1652,7 +1637,6 @@ static int ceph_snap_gmt_setxattr(struct vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1730,7 +1714,6 @@ static uint64_t ceph_snap_gmt_disk_free(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;
@@ -1776,7 +1759,6 @@ static int ceph_snap_gmt_get_quota(vfs_handle_struct *handle,
 	time_t timestamp = 0;
 	char stripped[PATH_MAX + 1];
 	char conv[PATH_MAX + 1];
-	char *tmp;
 	int ret;
 	struct smb_filename *new_fname;
 	int saved_errno;

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vfs_ceph_snapshots_v4.patchset"
Content-Transfer-Encoding: quoted-printable

=46rom 8d324cf9d5b271d74d2314c72e2f32e62e379fab Mon Sep 17 00:00:00 2001
=46rom: David Disseldorp <ddiss@samba.org>
Date: Wed, 27 Mar 2019 13:10:04 +0100
Subject: [PATCH 1/3] vfs_ceph: drop fdopendir handler

libcephfs doesn't currently offer an fdopendir equivalent, so the
existing implementation peeks at fsp->fsp_name->base_name, which can
break if vfs_ceph is used under a separate path-munging VFS module.

Return ENOSYS instead and rely on existing OpenDir_fsp() fallback.

Signed-off-by: David Disseldorp <ddiss@samba.org>
Reviewed-by: Jeremy Allison <jra@samba.org>
---
 source3/modules/vfs_ceph.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/source3/modules/vfs_ceph.c b/source3/modules/vfs_ceph.c
index 6f29629566e..e1f3d757bf1 100644
--- a/source3/modules/vfs_ceph.c
+++ b/source3/modules/vfs_ceph.c
@@ -328,18 +328,9 @@ static DIR *cephwrap_fdopendir(struct vfs_handle_struc=
t *handle,
 			       const char *mask,
 			       uint32_t attributes)
 {
-	int ret =3D 0;
-	struct ceph_dir_result *result;
-	DBG_DEBUG("[CEPH] fdopendir(%p, %p)\n", handle, fsp);
-
-	ret =3D ceph_opendir(handle->data, fsp->fsp_name->base_name, &result);
-	if (ret < 0) {
-		result =3D NULL;
-		errno =3D -ret; /* We return result which is NULL in this case */
-	}
-
-	DBG_DEBUG("[CEPH] fdopendir(...) =3D %d\n", ret);
-	return (DIR *) result;
+	/* OpenDir_fsp() falls back to regular open */
+	errno =3D ENOSYS;
+	return NULL;
 }
=20
 static struct dirent *cephwrap_readdir(struct vfs_handle_struct *handle,
--=20
2.21.0.1020.gf2820cf01a-goog


=46rom 7e6c78e0a09dc84393b8c710661384ed0457965a Mon Sep 17 00:00:00 2001
=46rom: David Disseldorp <ddiss@samba.org>
Date: Tue, 26 Mar 2019 16:35:18 +0100
Subject: [PATCH 2/3] vfs: add ceph_snapshots module

vfs_ceph_snapshots is a module for accessing CephFS snapshots as
Previous Versions. The module is separate from vfs_ceph, so that it can
also be used atop a CephFS kernel backed share with vfs_default.

Signed-off-by: David Disseldorp <ddiss@samba.org>
Reviewed-by: Jeremy Allison <jra@samba.org>
---
 source3/modules/vfs_ceph_snapshots.c | 1835 ++++++++++++++++++++++++++
 source3/modules/wscript_build        |    8 +
 source3/wscript                      |    5 +
 3 files changed, 1848 insertions(+)
 create mode 100644 source3/modules/vfs_ceph_snapshots.c

diff --git a/source3/modules/vfs_ceph_snapshots.c b/source3/modules/vfs_cep=
h_snapshots.c
new file mode 100644
index 00000000000..4183069a5c2
--- /dev/null
+++ b/source3/modules/vfs_ceph_snapshots.c
@@ -0,0 +1,1835 @@
+/*
+ * Module for accessing CephFS snapshots as Previous Versions. This module=
 is
+ * separate to vfs_ceph, so that it can also be used atop a CephFS kernel =
backed
+ * share with vfs_default.
+ *
+ * Copyright (C) David Disseldorp 2019
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <dirent.h>
+#include <libgen.h>
+#include "includes.h"
+#include "include/ntioctl.h"
+#include "include/smb.h"
+#include "system/filesys.h"
+#include "smbd/smbd.h"
+#include "lib/util/tevent_ntstatus.h"
+
+#undef DBGC_CLASS
+#define DBGC_CLASS DBGC_VFS
+
+/*
+ * CephFS has a magic snapshots subdirectory in all parts of the directory=
 tree.
+ * This module automatically makes all snapshots in this subdir visible to=
 SMB
+ * clients (if permitted by corresponding access control).
+ */
+#define CEPH_SNAP_SUBDIR_DEFAULT ".snap"
+/*
+ * The ceph.snap.btime (virtual) extended attribute carries the snapshot
+ * creation time in $secs.$nsecs format. It was added as part of
+ * https://tracker.ceph.com/issues/38838. Running Samba atop old Ceph vers=
ions
+ * which don't provide this xattr will not be able to enumerate or access
+ * snapshots using this module. As an alternative, vfs_shadow_copy2 could =
be
+ * used instead, alongside special shadow:format snapshot directory names.
+ */
+#define CEPH_SNAP_BTIME_XATTR "ceph.snap.btime"
+
+static int ceph_snap_get_btime(struct vfs_handle_struct *handle,
+			       struct smb_filename *smb_fname,
+			       time_t *_snap_secs)
+{
+	int ret;
+	char snap_btime[33];
+	char *s =3D NULL;
+	char *endptr =3D NULL;
+	struct timespec snap_timespec;
+	int err;
+
+	ret =3D SMB_VFS_NEXT_GETXATTR(handle, smb_fname, CEPH_SNAP_BTIME_XATTR,
+				    snap_btime, sizeof(snap_btime));
+	if (ret < 0) {
+		DBG_ERR("failed to get %s xattr: %s\n",
+			CEPH_SNAP_BTIME_XATTR, strerror(errno));
+		return -errno;
+	}
+
+	if (ret =3D=3D 0 || ret >=3D sizeof(snap_btime) - 1) {
+		return -EINVAL;
+	}
+
+	/* ensure zero termination */
+	snap_btime[ret] =3D '\0';
+
+	/* format is sec.nsec */
+	s =3D strchr(snap_btime, '.');
+	if (s =3D=3D NULL) {
+		DBG_ERR("invalid %s xattr value: %s\n",
+			CEPH_SNAP_BTIME_XATTR, snap_btime);
+		return -EINVAL;
+	}
+
+	/* First component is seconds, extract it */
+	*s =3D '\0';
+	snap_timespec.tv_sec =3D strtoull_err(snap_btime, &endptr, 10, &err);
+	if (err !=3D 0) {
+		return -err;
+	}
+	if ((endptr =3D=3D snap_btime) || (*endptr !=3D '\0')) {
+		DBG_ERR("couldn't process snap.tv_sec in %s\n", snap_btime);
+		return -EINVAL;
+	}
+
+	/* second component is nsecs */
+	s++;
+	snap_timespec.tv_nsec =3D strtoul_err(s, &endptr, 10, &err);
+	if (err !=3D 0) {
+		return -err;
+	}
+	if ((endptr =3D=3D s) || (*endptr !=3D '\0')) {
+		DBG_ERR("couldn't process snap.tv_nsec in %s\n", s);
+		return -EINVAL;
+	}
+
+	/*
+	 * >> 30 is a rough divide by ~10**9. No need to be exact, as @GMT
+	 * tokens only offer 1-second resolution (while twrp is nsec).
+	 */
+	*_snap_secs =3D snap_timespec.tv_sec + (snap_timespec.tv_nsec >> 30);
+
+	return 0;
+}
+
+/*
+ * XXX Ceph snapshots can be created with sub-second granularity, which me=
ans
+ * that multiple snapshots may be mapped to the same @GMT- label.
+ *
+ * @this_label is a pre-zeroed buffer to be filled with a @GMT label
+ * @return 0 if label successfully filled or -errno on error.
+ */
+static int ceph_snap_fill_label(struct vfs_handle_struct *handle,
+				TALLOC_CTX *tmp_ctx,
+				const char *parent_snapsdir,
+				const char *subdir,
+				SHADOW_COPY_LABEL this_label)
+{
+	struct smb_filename *smb_fname;
+	time_t snap_secs;
+	struct tm gmt_snap_time;
+	struct tm *tm_ret;
+	size_t str_sz;
+	char snap_path[PATH_MAX + 1];
+	int ret;
+
+	/*
+	 * CephFS snapshot creation times are available via a special
+	 * xattr - snapshot b/m/ctimes all match the snap source.
+	 */
+	ret =3D snprintf(snap_path, sizeof(snap_path), "%s/%s",
+			parent_snapsdir, subdir);
+	if (ret >=3D sizeof(snap_path)) {
+		return -EINVAL;
+	}
+
+	smb_fname =3D synthetic_smb_fname(tmp_ctx, snap_path,
+					NULL, NULL, 0);
+	if (smb_fname =3D=3D NULL) {
+		return -ENOMEM;
+	}
+
+	ret =3D ceph_snap_get_btime(handle, smb_fname, &snap_secs);
+	if (ret < 0) {
+		return ret;
+	}
+
+	tm_ret =3D gmtime_r(&snap_secs, &gmt_snap_time);
+	if (tm_ret =3D=3D NULL) {
+		return -EINVAL;
+	}
+	str_sz =3D strftime(this_label, sizeof(SHADOW_COPY_LABEL),
+			  "@GMT-%Y.%m.%d-%H.%M.%S", &gmt_snap_time);
+	if (str_sz =3D=3D 0) {
+		DBG_ERR("failed to convert tm to @GMT token\n");
+		return -EINVAL;
+	}
+
+	DBG_DEBUG("mapped snapshot at %s to enum snaps label %s\n",
+		  snap_path, this_label);
+
+	return 0;
+}
+
+static int ceph_snap_enum_snapdir(struct vfs_handle_struct *handle,
+				  struct smb_filename *snaps_dname,
+				  bool labels,
+				  struct shadow_copy_data *sc_data)
+{
+	NTSTATUS status;
+	int ret;
+	DIR *d =3D NULL;
+	struct dirent *e =3D NULL;
+	uint32_t slots;
+
+	status =3D smbd_check_access_rights(handle->conn,
+					snaps_dname,
+					false,
+					SEC_DIR_LIST);
+	if (!NT_STATUS_IS_OK(status)) {
+		DEBUG(0,("user does not have list permission "
+			"on snapdir %s\n",
+			snaps_dname->base_name));
+		ret =3D -map_errno_from_nt_status(status);
+		goto err_out;
+	}
+
+	DBG_DEBUG("enumerating shadow copy dir at %s\n",
+		  snaps_dname->base_name);
+
+	/*
+	 * CephFS stat(dir).size *normally* returns the number of child entries
+	 * for a given dir, but it unfortunately that's not the case for the one
+	 * place we need it (dir=3D.snap), so we need to dynamically determine it
+	 * via readdir.
+	 */
+	d =3D SMB_VFS_NEXT_OPENDIR(handle, snaps_dname, NULL, 0);
+	if (d =3D=3D NULL) {
+		ret =3D -errno;
+		goto err_out;
+	}
+
+	slots =3D 0;
+	sc_data->num_volumes =3D 0;
+	sc_data->labels =3D NULL;
+
+	for (e =3D SMB_VFS_NEXT_READDIR(handle, d, NULL);
+	     e !=3D NULL;
+	     e =3D SMB_VFS_NEXT_READDIR(handle, d, NULL)) {
+		if (ISDOT(e->d_name) || ISDOTDOT(e->d_name)) {
+			continue;
+		}
+		sc_data->num_volumes++;
+		if (!labels) {
+			continue;
+		}
+		if (sc_data->num_volumes > slots) {
+			uint32_t new_slot_count =3D slots + 10;
+			SMB_ASSERT(new_slot_count > slots);
+			sc_data->labels =3D talloc_realloc(sc_data,
+							 sc_data->labels,
+							 SHADOW_COPY_LABEL,
+							 new_slot_count);
+			if (sc_data->labels =3D=3D NULL) {
+				ret =3D -ENOMEM;
+				goto err_closedir;
+			}
+			memset(sc_data->labels[slots], 0,
+			       sizeof(SHADOW_COPY_LABEL) * 10);
+
+			DBG_DEBUG("%d->%d slots for enum_snaps response\n",
+				  slots, new_slot_count);
+			slots =3D new_slot_count;
+		}
+		DBG_DEBUG("filling shadow copy label for %s/%s\n",
+			  snaps_dname->base_name, e->d_name);
+		ret =3D ceph_snap_fill_label(handle, snaps_dname,
+				snaps_dname->base_name, e->d_name,
+				sc_data->labels[sc_data->num_volumes - 1]);
+		if (ret < 0) {
+			goto err_closedir;
+		}
+	}
+
+	ret =3D SMB_VFS_NEXT_CLOSEDIR(handle, d);
+	if (ret !=3D 0) {
+		ret =3D -errno;
+		goto err_out;
+	}
+
+	DBG_DEBUG("%s shadow copy enumeration found %d labels \n",
+		  snaps_dname->base_name, sc_data->num_volumes);
+
+	return 0;
+
+err_closedir:
+	SMB_VFS_NEXT_CLOSEDIR(handle, d);
+err_out:
+	TALLOC_FREE(sc_data->labels);
+	return ret;
+}
+
+/*
+ * Prior reading: The Meaning of Path Names
+ *   https://wiki.samba.org/index.php/Writing_a_Samba_VFS_Module
+ *
+ * translate paths so that we can use the parent dir for .snap access:
+ *   myfile        -> parent=3D        trimmed=3Dmyfile
+ *   /a            -> parent=3D/       trimmed=3Da
+ *   dir/sub/file  -> parent=3Ddir/sub trimmed=3Dfile
+ *   /dir/sub      -> parent=3D/dir/   trimmed=3Dsub
+ */
+static int ceph_snap_get_parent_path(const char *connectpath,
+				     const char *path,
+				     char *_parent_buf,
+				     size_t buflen,
+				     const char **_trimmed)
+{
+	const char *p;
+	size_t len;
+	int ret;
+
+	if (!strcmp(path, "/")) {
+		DBG_ERR("can't go past root for %s .snap dir\n", path);
+		return -EINVAL;
+	}
+
+	p =3D strrchr_m(path, '/'); /* Find final '/', if any */
+	if (p =3D=3D NULL) {
+		DBG_DEBUG("parent .snap dir for %s is cwd\n", path);
+		ret =3D strlcpy(_parent_buf, "", buflen);
+		if (ret >=3D buflen) {
+			return -EINVAL;
+		}
+		if (_trimmed !=3D NULL) {
+			*_trimmed =3D path;
+		}
+		return 0;
+	}
+
+	SMB_ASSERT(p >=3D path);
+	len =3D p - path;
+
+	ret =3D snprintf(_parent_buf, buflen, "%.*s", (int)len, path);
+	if (ret >=3D buflen) {
+		return -EINVAL;
+	}
+
+	/* for absolute paths, check that we're not going outside the share */
+	if ((len > 0) && (_parent_buf[0] =3D=3D '/')) {
+		bool connectpath_match =3D false;
+		size_t clen =3D strlen(connectpath);
+		DBG_DEBUG("checking absolute path %s lies within share at %s\n",
+			  _parent_buf, connectpath);
+		/* need to check for separator, to avoid /x/abcd vs /x/ab */
+		connectpath_match =3D (strncmp(connectpath,
+					_parent_buf,
+					clen) =3D=3D 0);
+		if (!connectpath_match
+		 || ((_parent_buf[clen] !=3D '/') && (_parent_buf[clen] !=3D '\0'))) {
+			DBG_ERR("%s parent path is outside of share at %s\n",
+				_parent_buf, connectpath);
+			return -EINVAL;
+		}
+	}
+
+	if (_trimmed !=3D NULL) {
+		/*
+		 * point to path component which was trimmed from _parent_buf
+		 * excluding path separator.
+		 */
+		*_trimmed =3D p + 1;
+	}
+
+	DBG_DEBUG("generated parent .snap path for %s as %s (trimmed \"%s\")\n",
+		  path, _parent_buf, p + 1);
+
+	return 0;
+}
+
+static int ceph_snap_get_shadow_copy_data(struct vfs_handle_struct *handle,
+					struct files_struct *fsp,
+					struct shadow_copy_data *sc_data,
+					bool labels)
+{
+	int ret;
+	TALLOC_CTX *tmp_ctx;
+	const char *parent_dir =3D NULL;
+	char tmp[PATH_MAX + 1];
+	char snaps_path[PATH_MAX + 1];
+	struct smb_filename *snaps_dname =3D NULL;
+	const char *snapdir =3D lp_parm_const_string(SNUM(handle->conn),
+						   "ceph", "snapdir",
+						   CEPH_SNAP_SUBDIR_DEFAULT);
+
+	DBG_DEBUG("getting shadow copy data for %s\n",
+		  fsp->fsp_name->base_name);
+
+	tmp_ctx =3D talloc_new(fsp);
+	if (tmp_ctx =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_out;
+	}
+
+	if (sc_data =3D=3D NULL) {
+		ret =3D -EINVAL;
+		goto err_out;
+	}
+
+	if (fsp->is_directory) {
+		parent_dir =3D fsp->fsp_name->base_name;
+	} else {
+		ret =3D ceph_snap_get_parent_path(handle->conn->connectpath,
+						fsp->fsp_name->base_name,
+						tmp,
+						sizeof(tmp),
+						NULL);	/* trimmed */
+		if (ret < 0) {
+			goto err_out;
+		}
+		parent_dir =3D tmp;
+	}
+
+	ret =3D snprintf(snaps_path, sizeof(snaps_path), "%s/%s",
+		       parent_dir, snapdir);
+	if (ret >=3D sizeof(snaps_path)) {
+		ret =3D -EINVAL;
+		goto err_out;
+	}
+
+	snaps_dname =3D synthetic_smb_fname(tmp_ctx,
+				snaps_path,
+				NULL,
+				NULL,
+				fsp->fsp_name->flags);
+	if (snaps_dname =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_out;
+	}
+
+	ret =3D ceph_snap_enum_snapdir(handle, snaps_dname, labels, sc_data);
+	if (ret < 0) {
+		goto err_out;
+	}
+
+	talloc_free(tmp_ctx);
+	return 0;
+
+err_out:
+	talloc_free(tmp_ctx);
+	errno =3D -ret;
+	return -1;
+}
+
+static bool ceph_snap_gmt_strip_snapshot(struct vfs_handle_struct *handle,
+					 const char *name,
+					 time_t *_timestamp,
+					 char *_stripped_buf,
+					 size_t buflen)
+{
+	struct tm tm;
+	time_t timestamp;
+	const char *p;
+	char *q;
+	size_t rest_len, dst_len;
+	ptrdiff_t len_before_gmt;
+
+	p =3D strstr_m(name, "@GMT-");
+	if (p =3D=3D NULL) {
+		goto no_snapshot;
+	}
+	if ((p > name) && (p[-1] !=3D '/')) {
+		goto no_snapshot;
+	}
+	len_before_gmt =3D p - name;
+	q =3D strptime(p, GMT_FORMAT, &tm);
+	if (q =3D=3D NULL) {
+		goto no_snapshot;
+	}
+	tm.tm_isdst =3D -1;
+	timestamp =3D timegm(&tm);
+	if (timestamp =3D=3D (time_t)-1) {
+		goto no_snapshot;
+	}
+	if (q[0] =3D=3D '\0') {
+		/*
+		 * The name consists of only the GMT token or the GMT
+		 * token is at the end of the path.
+		 */
+		if (_stripped_buf !=3D NULL) {
+			if (len_before_gmt >=3D buflen) {
+				return -EINVAL;
+			}
+			if (len_before_gmt > 0) {
+				/*
+				 * There is a slash before the @GMT-. Remove it
+				 * and copy the result.
+				 */
+				len_before_gmt -=3D 1;
+				strlcpy(_stripped_buf, name, len_before_gmt);
+			} else {
+				_stripped_buf[0] =3D '\0';	/* token only */
+			}
+			DBG_DEBUG("GMT token in %s stripped to %s\n",
+				  name, _stripped_buf);
+		}
+		*_timestamp =3D timestamp;
+		return 0;
+	}
+	if (q[0] !=3D '/') {
+		/*
+		 * It is not a complete path component, i.e. the path
+		 * component continues after the gmt-token.
+		 */
+		goto no_snapshot;
+	}
+	q +=3D 1;
+
+	rest_len =3D strlen(q);
+	dst_len =3D len_before_gmt + rest_len;
+	SMB_ASSERT(dst_len >=3D rest_len);
+
+	if (_stripped_buf !=3D NULL) {
+		if (dst_len >=3D buflen) {
+			return -EINVAL;
+		}
+		if (p > name) {
+			memcpy(_stripped_buf, name, len_before_gmt);
+		}
+		if (rest_len > 0) {
+			memcpy(_stripped_buf + len_before_gmt, q, rest_len);
+		}
+		_stripped_buf[dst_len] =3D '\0';
+	}
+	*_timestamp =3D timestamp;
+	DBG_DEBUG("GMT token in %s stripped to %s\n", name, _stripped_buf);
+	return 0;
+no_snapshot:
+	*_timestamp =3D 0;
+	return 0;
+}
+
+static int ceph_snap_gmt_convert_dir(struct vfs_handle_struct *handle,
+				     const char *name,
+				     time_t timestamp,
+				     char *_converted_buf,
+				     size_t buflen)
+{
+	int ret;
+	NTSTATUS status;
+	DIR *d =3D NULL;
+	struct dirent *e =3D NULL;
+	struct smb_filename *snaps_dname =3D NULL;
+	const char *snapdir =3D lp_parm_const_string(SNUM(handle->conn),
+						   "ceph", "snapdir",
+						   CEPH_SNAP_SUBDIR_DEFAULT);
+	TALLOC_CTX *tmp_ctx =3D talloc_new(NULL);
+
+	if (tmp_ctx =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_out;
+	}
+
+	/*
+	 * Temporally use the caller's return buffer for this.
+	 */
+	ret =3D snprintf(_converted_buf, buflen, "%s/%s", name, snapdir);
+	if (ret >=3D buflen) {
+		ret =3D -EINVAL;
+		goto err_out;
+	}
+
+	snaps_dname =3D synthetic_smb_fname(tmp_ctx,
+				_converted_buf,
+				NULL,
+				NULL,
+				0);	/* XXX check? */
+	if (snaps_dname =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_out;
+	}
+
+	/* stat first to trigger error fallback in ceph_snap_gmt_convert() */
+	ret =3D SMB_VFS_NEXT_STAT(handle, snaps_dname);
+	if (ret < 0) {
+		ret =3D -errno;
+		goto err_out;
+	}
+
+	status =3D smbd_check_access_rights(handle->conn,
+					snaps_dname,
+					false,
+					SEC_DIR_LIST);
+	if (!NT_STATUS_IS_OK(status)) {
+		DEBUG(0,("user does not have list permission "
+			"on snapdir %s\n",
+			snaps_dname->base_name));
+		ret =3D -map_errno_from_nt_status(status);
+		goto err_out;
+	}
+
+	DBG_DEBUG("enumerating shadow copy dir at %s\n",
+		  snaps_dname->base_name);
+
+	d =3D SMB_VFS_NEXT_OPENDIR(handle, snaps_dname, NULL, 0);
+	if (d =3D=3D NULL) {
+		ret =3D -errno;
+		goto err_out;
+	}
+
+	for (e =3D SMB_VFS_NEXT_READDIR(handle, d, NULL);
+	     e !=3D NULL;
+	     e =3D SMB_VFS_NEXT_READDIR(handle, d, NULL)) {
+		struct smb_filename *smb_fname;
+		time_t snap_secs;
+
+		if (ISDOT(e->d_name) || ISDOTDOT(e->d_name)) {
+			continue;
+		}
+
+		ret =3D snprintf(_converted_buf, buflen, "%s/%s",
+			       snaps_dname->base_name, e->d_name);
+		if (ret >=3D buflen) {
+			ret =3D -EINVAL;
+			goto err_closedir;
+		}
+
+		smb_fname =3D synthetic_smb_fname(tmp_ctx, _converted_buf,
+						NULL, NULL, 0);
+		if (smb_fname =3D=3D NULL) {
+			ret =3D -ENOMEM;
+			goto err_closedir;
+		}
+
+		ret =3D ceph_snap_get_btime(handle, smb_fname, &snap_secs);
+		if (ret < 0) {
+			goto err_closedir;
+		}
+
+		/*
+		 * check gmt_snap_time matches @timestamp
+		 */
+		if (timestamp =3D=3D snap_secs) {
+			break;
+		}
+		DBG_DEBUG("[connectpath %s] %s@%lld no match for snap %s@%lld\n",
+			  handle->conn->connectpath, name, (long long)timestamp,
+			  e->d_name, (long long)snap_secs);
+	}
+
+	if (e =3D=3D NULL) {
+		DBG_INFO("[connectpath %s] failed to find %s @ time %lld\n",
+			 handle->conn->connectpath, name, (long long)timestamp);
+		ret =3D -ENOENT;
+		goto err_closedir;
+	}
+
+	/* found, _converted_buf already contains path of interest */
+	DBG_DEBUG("[connectpath %s] converted %s @ time %lld to %s\n",
+		  handle->conn->connectpath, name, (long long)timestamp,
+		  _converted_buf);
+
+	ret =3D SMB_VFS_NEXT_CLOSEDIR(handle, d);
+	if (ret !=3D 0) {
+		ret =3D -errno;
+		goto err_out;
+	}
+	talloc_free(tmp_ctx);
+	return 0;
+
+err_closedir:
+	SMB_VFS_NEXT_CLOSEDIR(handle, d);
+err_out:
+	talloc_free(tmp_ctx);
+	return ret;
+}
+
+static int ceph_snap_gmt_convert(struct vfs_handle_struct *handle,
+				     const char *name,
+				     time_t timestamp,
+				     char *_converted_buf,
+				     size_t buflen)
+{
+	int ret;
+	char parent[PATH_MAX + 1];
+	const char *trimmed =3D NULL;
+	/*
+	 * CephFS Snapshots for a given dir are nested under the ./.snap subdir
+	 * *or* under ../.snap/dir (and subsequent parent dirs).
+	 * Child dirs inherit snapshots created in parent dirs if the child
+	 * exists at the time of snapshot creation.
+	 *
+	 * At this point we don't know whether @name refers to a file or dir, so
+	 * first assume it's a dir (with a corresponding .snaps subdir)
+	 */
+	ret =3D ceph_snap_gmt_convert_dir(handle,
+					name,
+					timestamp,
+					_converted_buf,
+					buflen);
+	if (ret >=3D 0) {
+		/* all done: .snap subdir exists - @name is a dir */
+		DBG_DEBUG("%s is a dir, accessing snaps via .snap\n", name);
+		return ret;
+	}
+
+	/* @name/.snap access failed, attempt snapshot access via parent */
+	DBG_DEBUG("%s/.snap access failed, attempting parent access\n",
+		  name);
+
+	ret =3D ceph_snap_get_parent_path(handle->conn->connectpath,
+					name,
+					parent,
+					sizeof(parent),
+					&trimmed);
+	if (ret < 0) {
+		return ret;
+	}
+
+	ret =3D ceph_snap_gmt_convert_dir(handle,
+					parent,
+					timestamp,
+					_converted_buf,
+					buflen);
+	if (ret < 0) {
+		return ret;
+	}
+
+	/*
+	 * found snapshot via parent. Append the child path component
+	 * that was trimmed... +1 for path separator + 1 for null termination.
+	 */
+	if (strlen(_converted_buf) + 1 + strlen(trimmed) + 1 > buflen) {
+		return -EINVAL;
+	}
+	strlcat(_converted_buf, "/", buflen);
+	strlcat(_converted_buf, trimmed, buflen);
+
+	return 0;
+}
+
+static DIR *ceph_snap_gmt_opendir(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				const char *mask,
+				uint32_t attr)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	int ret;
+	DIR *dir;
+	int saved_errno;
+	struct smb_filename *conv_smb_fname =3D NULL;
+	char conv[PATH_MAX + 1];
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+			csmb_fname->base_name,
+			&timestamp,
+			stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return NULL;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_OPENDIR(handle, csmb_fname, mask, attr);
+	}
+	ret =3D ceph_snap_gmt_convert_dir(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return NULL;
+	}
+	conv_smb_fname =3D synthetic_smb_fname(talloc_tos(),
+					conv,
+					NULL,
+					NULL,
+					csmb_fname->flags);
+	if (conv_smb_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return NULL;
+	}
+
+	dir =3D SMB_VFS_NEXT_OPENDIR(handle, conv_smb_fname, mask, attr);
+	saved_errno =3D errno;
+	TALLOC_FREE(conv_smb_fname);
+	errno =3D saved_errno;
+	return dir;
+}
+
+static int ceph_snap_gmt_rename(vfs_handle_struct *handle,
+			      const struct smb_filename *smb_fname_src,
+			      const struct smb_filename *smb_fname_dst)
+{
+	int ret;
+	time_t timestamp_src, timestamp_dst;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					smb_fname_src->base_name,
+					&timestamp_src, NULL, 0);
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					smb_fname_dst->base_name,
+					&timestamp_dst, NULL, 0);
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp_src !=3D 0) {
+		errno =3D EXDEV;
+		return -1;
+	}
+	if (timestamp_dst !=3D 0) {
+		errno =3D EROFS;
+		return -1;
+	}
+	return SMB_VFS_NEXT_RENAME(handle, smb_fname_src, smb_fname_dst);
+}
+
+/* block links from writeable shares to snapshots for now, like other modu=
les */
+static int ceph_snap_gmt_symlink(vfs_handle_struct *handle,
+				const char *link_contents,
+				const struct smb_filename *new_smb_fname)
+{
+	int ret;
+	time_t timestamp_old =3D 0;
+	time_t timestamp_new =3D 0;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+				link_contents,
+				&timestamp_old,
+				NULL, 0);
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+				new_smb_fname->base_name,
+				&timestamp_new,
+				NULL, 0);
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if ((timestamp_old !=3D 0) || (timestamp_new !=3D 0)) {
+		errno =3D EROFS;
+		return -1;
+	}
+	return SMB_VFS_NEXT_SYMLINK(handle, link_contents, new_smb_fname);
+}
+
+static int ceph_snap_gmt_link(vfs_handle_struct *handle,
+				const struct smb_filename *old_smb_fname,
+				const struct smb_filename *new_smb_fname)
+{
+	int ret;
+	time_t timestamp_old =3D 0;
+	time_t timestamp_new =3D 0;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+				old_smb_fname->base_name,
+				&timestamp_old,
+				NULL, 0);
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+				new_smb_fname->base_name,
+				&timestamp_new,
+				NULL, 0);
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if ((timestamp_old !=3D 0) || (timestamp_new !=3D 0)) {
+		errno =3D EROFS;
+		return -1;
+	}
+	return SMB_VFS_NEXT_LINK(handle, old_smb_fname, new_smb_fname);
+}
+
+static int ceph_snap_gmt_stat(vfs_handle_struct *handle,
+			    struct smb_filename *smb_fname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	char *tmp;
+	int ret;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					smb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_STAT(handle, smb_fname);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	tmp =3D smb_fname->base_name;
+	smb_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_STAT(handle, smb_fname);
+	smb_fname->base_name =3D tmp;
+	return ret;
+}
+
+static int ceph_snap_gmt_lstat(vfs_handle_struct *handle,
+			     struct smb_filename *smb_fname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	char *tmp;
+	int ret;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					smb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_LSTAT(handle, smb_fname);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	tmp =3D smb_fname->base_name;
+	smb_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_LSTAT(handle, smb_fname);
+	smb_fname->base_name =3D tmp;
+	return ret;
+}
+
+static int ceph_snap_gmt_open(vfs_handle_struct *handle,
+			    struct smb_filename *smb_fname, files_struct *fsp,
+			    int flags, mode_t mode)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	char *tmp;
+	int ret;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					smb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_OPEN(handle, smb_fname, fsp, flags, mode);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	tmp =3D smb_fname->base_name;
+	smb_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_OPEN(handle, smb_fname, fsp, flags, mode);
+	smb_fname->base_name =3D tmp;
+	return ret;
+}
+
+static int ceph_snap_gmt_unlink(vfs_handle_struct *handle,
+			      const struct smb_filename *csmb_fname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_UNLINK(handle, csmb_fname);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_UNLINK(handle, new_fname);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_chmod(vfs_handle_struct *handle,
+			const struct smb_filename *csmb_fname,
+			mode_t mode)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_CHMOD(handle, csmb_fname, mode);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_CHMOD(handle, new_fname, mode);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_chown(vfs_handle_struct *handle,
+			const struct smb_filename *csmb_fname,
+			uid_t uid,
+			gid_t gid)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_CHOWN(handle, csmb_fname, uid, gid);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_CHOWN(handle, new_fname, uid, gid);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_chdir(vfs_handle_struct *handle,
+			const struct smb_filename *csmb_fname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_CHDIR(handle, csmb_fname);
+	}
+
+	ret =3D ceph_snap_gmt_convert_dir(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_CHDIR(handle, new_fname);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_ntimes(vfs_handle_struct *handle,
+			      const struct smb_filename *csmb_fname,
+			      struct smb_file_time *ft)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_NTIMES(handle, csmb_fname, ft);
+	}
+
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_NTIMES(handle, new_fname, ft);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_readlink(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				char *buf,
+				size_t bufsiz)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_READLINK(handle, csmb_fname, buf, bufsiz);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_READLINK(handle, new_fname, buf, bufsiz);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_mknod(vfs_handle_struct *handle,
+			const struct smb_filename *csmb_fname,
+			mode_t mode,
+			SMB_DEV_T dev)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_MKNOD(handle, csmb_fname, mode, dev);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_MKNOD(handle, new_fname, mode, dev);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static struct smb_filename *ceph_snap_gmt_realpath(vfs_handle_struct *hand=
le,
+				TALLOC_CTX *ctx,
+				const struct smb_filename *csmb_fname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	struct smb_filename *result_fname;
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return NULL;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_REALPATH(handle, ctx, csmb_fname);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return NULL;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return NULL;
+	}
+	new_fname->base_name =3D conv;
+
+	result_fname =3D SMB_VFS_NEXT_REALPATH(handle, ctx, new_fname);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return result_fname;
+}
+
+/*
+ * XXX this should have gone through open() conversion, so why do we need
+ * a handler here? posix_fget_nt_acl() falls back to posix_get_nt_acl() for
+ * dirs (or fd =3D=3D -1).
+ */
+static NTSTATUS ceph_snap_gmt_fget_nt_acl(vfs_handle_struct *handle,
+					struct files_struct *fsp,
+					uint32_t security_info,
+					TALLOC_CTX *mem_ctx,
+					struct security_descriptor **ppdesc)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	struct smb_filename *smb_fname;
+	int ret;
+	NTSTATUS status;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					fsp->fsp_name->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		return map_nt_error_from_unix(-ret);
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_FGET_NT_ACL(handle, fsp, security_info,
+						mem_ctx,
+						ppdesc);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		return map_nt_error_from_unix(-ret);
+	}
+
+	smb_fname =3D synthetic_smb_fname(mem_ctx,
+					conv,
+					NULL,
+					NULL,
+					fsp->fsp_name->flags);
+	if (smb_fname =3D=3D NULL) {
+		return NT_STATUS_NO_MEMORY;
+	}
+
+	status =3D SMB_VFS_NEXT_GET_NT_ACL(handle, smb_fname, security_info,
+					 mem_ctx, ppdesc);
+	TALLOC_FREE(smb_fname);
+	return status;
+}
+
+static NTSTATUS ceph_snap_gmt_get_nt_acl(vfs_handle_struct *handle,
+				       const struct smb_filename *csmb_fname,
+				       uint32_t security_info,
+				       TALLOC_CTX *mem_ctx,
+				       struct security_descriptor **ppdesc)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	NTSTATUS status;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		return map_nt_error_from_unix(-ret);
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_GET_NT_ACL(handle, csmb_fname, security_info,
+					       mem_ctx, ppdesc);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		return map_nt_error_from_unix(-ret);
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		return NT_STATUS_NO_MEMORY;
+	}
+	new_fname->base_name =3D conv;
+
+	status =3D SMB_VFS_NEXT_GET_NT_ACL(handle, new_fname, security_info,
+					 mem_ctx, ppdesc);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return status;
+}
+
+static int ceph_snap_gmt_mkdir(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				mode_t mode)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_MKDIR(handle, csmb_fname, mode);
+	}
+	ret =3D ceph_snap_gmt_convert_dir(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_MKDIR(handle, new_fname, mode);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_rmdir(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_RMDIR(handle, csmb_fname);
+	}
+	ret =3D ceph_snap_gmt_convert_dir(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_RMDIR(handle, new_fname);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_chflags(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				unsigned int flags)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_CHFLAGS(handle, csmb_fname, flags);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_CHFLAGS(handle, new_fname, flags);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static ssize_t ceph_snap_gmt_getxattr(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				const char *aname,
+				void *value,
+				size_t size)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_GETXATTR(handle, csmb_fname, aname, value,
+					     size);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_GETXATTR(handle, new_fname, aname, value, size);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static ssize_t ceph_snap_gmt_listxattr(struct vfs_handle_struct *handle,
+				     const struct smb_filename *csmb_fname,
+				     char *list, size_t size)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_LISTXATTR(handle, csmb_fname, list, size);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_LISTXATTR(handle, new_fname, list, size);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_removexattr(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				const char *aname)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_REMOVEXATTR(handle, csmb_fname, aname);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_REMOVEXATTR(handle, new_fname, aname);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_setxattr(struct vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				const char *aname, const void *value,
+				size_t size, int flags)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_SETXATTR(handle, csmb_fname,
+					aname, value, size, flags);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_SETXATTR(handle, new_fname,
+				aname, value, size, flags);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_get_real_filename(struct vfs_handle_struct *handl=
e,
+					 const char *path,
+					 const char *name,
+					 TALLOC_CTX *mem_ctx,
+					 char **found_name)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle, path,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_GET_REAL_FILENAME(handle, path, name,
+						      mem_ctx, found_name);
+	}
+	ret =3D ceph_snap_gmt_convert_dir(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	ret =3D SMB_VFS_NEXT_GET_REAL_FILENAME(handle, conv, name,
+					     mem_ctx, found_name);
+	return ret;
+}
+
+static uint64_t ceph_snap_gmt_disk_free(vfs_handle_struct *handle,
+				const struct smb_filename *csmb_fname,
+				uint64_t *bsize,
+				uint64_t *dfree,
+				uint64_t *dsize)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_DISK_FREE(handle, csmb_fname,
+					      bsize, dfree, dsize);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_DISK_FREE(handle, new_fname,
+				bsize, dfree, dsize);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static int ceph_snap_gmt_get_quota(vfs_handle_struct *handle,
+			const struct smb_filename *csmb_fname,
+			enum SMB_QUOTA_TYPE qtype,
+			unid_t id,
+			SMB_DISK_QUOTA *dq)
+{
+	time_t timestamp =3D 0;
+	char stripped[PATH_MAX + 1];
+	char conv[PATH_MAX + 1];
+	int ret;
+	struct smb_filename *new_fname;
+	int saved_errno;
+
+	ret =3D ceph_snap_gmt_strip_snapshot(handle,
+					csmb_fname->base_name,
+					&timestamp, stripped, sizeof(stripped));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	if (timestamp =3D=3D 0) {
+		return SMB_VFS_NEXT_GET_QUOTA(handle, csmb_fname, qtype, id, dq);
+	}
+	ret =3D ceph_snap_gmt_convert(handle, stripped,
+					timestamp, conv, sizeof(conv));
+	if (ret < 0) {
+		errno =3D -ret;
+		return -1;
+	}
+	new_fname =3D cp_smb_filename(talloc_tos(), csmb_fname);
+	if (new_fname =3D=3D NULL) {
+		errno =3D ENOMEM;
+		return -1;
+	}
+	new_fname->base_name =3D conv;
+
+	ret =3D SMB_VFS_NEXT_GET_QUOTA(handle, new_fname, qtype, id, dq);
+	saved_errno =3D errno;
+	TALLOC_FREE(new_fname);
+	errno =3D saved_errno;
+	return ret;
+}
+
+static struct vfs_fn_pointers ceph_snap_fns =3D {
+	.get_shadow_copy_data_fn =3D ceph_snap_get_shadow_copy_data,
+	.opendir_fn =3D ceph_snap_gmt_opendir,
+	.disk_free_fn =3D ceph_snap_gmt_disk_free,
+	.get_quota_fn =3D ceph_snap_gmt_get_quota,
+	.rename_fn =3D ceph_snap_gmt_rename,
+	.link_fn =3D ceph_snap_gmt_link,
+	.symlink_fn =3D ceph_snap_gmt_symlink,
+	.stat_fn =3D ceph_snap_gmt_stat,
+	.lstat_fn =3D ceph_snap_gmt_lstat,
+	.open_fn =3D ceph_snap_gmt_open,
+	.unlink_fn =3D ceph_snap_gmt_unlink,
+	.chmod_fn =3D ceph_snap_gmt_chmod,
+	.chown_fn =3D ceph_snap_gmt_chown,
+	.chdir_fn =3D ceph_snap_gmt_chdir,
+	.ntimes_fn =3D ceph_snap_gmt_ntimes,
+	.readlink_fn =3D ceph_snap_gmt_readlink,
+	.mknod_fn =3D ceph_snap_gmt_mknod,
+	.realpath_fn =3D ceph_snap_gmt_realpath,
+	.get_nt_acl_fn =3D ceph_snap_gmt_get_nt_acl,
+	.fget_nt_acl_fn =3D ceph_snap_gmt_fget_nt_acl,
+	.get_nt_acl_fn =3D ceph_snap_gmt_get_nt_acl,
+	.mkdir_fn =3D ceph_snap_gmt_mkdir,
+	.rmdir_fn =3D ceph_snap_gmt_rmdir,
+	.getxattr_fn =3D ceph_snap_gmt_getxattr,
+	.getxattrat_send_fn =3D vfs_not_implemented_getxattrat_send,
+	.getxattrat_recv_fn =3D vfs_not_implemented_getxattrat_recv,
+	.listxattr_fn =3D ceph_snap_gmt_listxattr,
+	.removexattr_fn =3D ceph_snap_gmt_removexattr,
+	.setxattr_fn =3D ceph_snap_gmt_setxattr,
+	.chflags_fn =3D ceph_snap_gmt_chflags,
+	.get_real_filename_fn =3D ceph_snap_gmt_get_real_filename,
+};
+
+static_decl_vfs;
+NTSTATUS vfs_ceph_snapshots_init(TALLOC_CTX *ctx)
+{
+	return smb_register_vfs(SMB_VFS_INTERFACE_VERSION,
+				"ceph_snapshots", &ceph_snap_fns);
+}
diff --git a/source3/modules/wscript_build b/source3/modules/wscript_build
index 8d0e0ee57c1..35010bb0e3b 100644
--- a/source3/modules/wscript_build
+++ b/source3/modules/wscript_build
@@ -522,6 +522,14 @@ bld.SAMBA3_MODULE('vfs_ceph',
                  cflags=3Dbld.CONFIG_GET('CFLAGS_CEPHFS'),
                  includes=3Dbld.CONFIG_GET('CPPPATH_CEPHFS'))
=20
+bld.SAMBA3_MODULE('vfs_ceph_snapshots',
+                 subsystem=3D'vfs',
+                 source=3D'vfs_ceph_snapshots.c',
+                 deps=3D'samba-util',
+                 init_function=3D'',
+                 internal_module=3Dbld.SAMBA3_IS_STATIC_MODULE('vfs_ceph_s=
napshots'),
+                 enabled=3Dbld.SAMBA3_IS_ENABLED_MODULE('vfs_ceph_snapshot=
s'))
+
 bld.SAMBA3_MODULE('vfs_glusterfs',
                   subsystem=3D'vfs',
                   source=3D'vfs_glusterfs.c',
diff --git a/source3/wscript b/source3/wscript
index cd0673a94c7..ff72a173a4b 100644
--- a/source3/wscript
+++ b/source3/wscript
@@ -1766,6 +1766,11 @@ main() {
=20
     if conf.CONFIG_SET("HAVE_CEPH"):
         default_shared_modules.extend(TO_LIST('vfs_ceph'))
+        # Unlike vfs_ceph, vfs_ceph_snapshots doesn't depend on libcephfs,=
 so
+        # can be enabled atop a kernel CephFS share (with vfs_default) in
+        # addition to vfs_ceph. Still, only enable vfs_ceph_snapshots buil=
ds
+        # if we're building with libcephfs for now.
+        default_shared_modules.extend(TO_LIST('vfs_ceph_snapshots'))
=20
     if conf.CONFIG_SET('HAVE_GLUSTERFS'):
         default_shared_modules.extend(TO_LIST('vfs_glusterfs'))
--=20
2.21.0.1020.gf2820cf01a-goog


=46rom 8f84c60bcc1530f94a919133b48132120b98ba87 Mon Sep 17 00:00:00 2001
=46rom: David Disseldorp <ddiss@samba.org>
Date: Wed, 27 Mar 2019 15:57:45 +0100
Subject: [PATCH 3/3] docs: add vfs_ceph_snapshots manpage

Signed-off-by: David Disseldorp <ddiss@samba.org>
Reviewed-by: Jeremy Allison <jra@samba.org>
---
 docs-xml/manpages/vfs_ceph_snapshots.8.xml | 130 +++++++++++++++++++++
 docs-xml/wscript_build                     |   1 +
 2 files changed, 131 insertions(+)
 create mode 100644 docs-xml/manpages/vfs_ceph_snapshots.8.xml

diff --git a/docs-xml/manpages/vfs_ceph_snapshots.8.xml b/docs-xml/manpages=
/vfs_ceph_snapshots.8.xml
new file mode 100644
index 00000000000..7fa2806fd95
--- /dev/null
+++ b/docs-xml/manpages/vfs_ceph_snapshots.8.xml
@@ -0,0 +1,130 @@
+<?xml version=3D"1.0" encoding=3D"iso-8859-1"?>
+<!DOCTYPE refentry PUBLIC "-//Samba-Team//DTD DocBook V4.2-Based Variant V=
1.0//EN" "http://www.samba.org/samba/DTD/samba-doc">
+<refentry id=3D"vfs_ceph_snapshots.8">
+
+<refmeta>
+	<refentrytitle>vfs_ceph_snapshots</refentrytitle>
+	<manvolnum>8</manvolnum>
+	<refmiscinfo class=3D"source">Samba</refmiscinfo>
+	<refmiscinfo class=3D"manual">System Administration tools</refmiscinfo>
+	<refmiscinfo class=3D"version">&doc.version;</refmiscinfo>
+</refmeta>
+
+
+<refnamediv>
+	<refname>vfs_ceph_snapshots</refname>
+	<refpurpose>
+		Expose CephFS snapshots as shadow-copies
+	</refpurpose>
+</refnamediv>
+
+<refsynopsisdiv>
+	<cmdsynopsis>
+		<command>vfs objects =3D ceph_snapshots</command>
+	</cmdsynopsis>
+</refsynopsisdiv>
+
+<refsect1>
+	<title>DESCRIPTION</title>
+
+	<para>This VFS module is part of the
+	<citerefentry><refentrytitle>samba</refentrytitle>
+	<manvolnum>8</manvolnum></citerefentry> suite.</para>
+
+	<para>
+		The <command>vfs_ceph_snapshots</command> VFS module exposes
+		CephFS snapshots for use by Samba. When enabled, SMB clients
+		such as Windows Explorer's Previous Versions dialog, can
+		enumerate snaphots and access them via "timewarp" tokens.
+	</para>
+
+	<para>
+		This module can be combined with <command>vfs_ceph</command>,
+		but <command>vfs_ceph_snapshots</command> must be listed first
+		in the <command>vfs objects</command> parameter list.
+	</para>
+
+	<para>
+		CephFS support for ceph.snap.btime virtual extended attributes
+		is required for this module to work properly. This support was
+		added via https://tracker.ceph.com/issues/38838.
+	</para>
+</refsect1>
+
+<refsect1>
+	<title>CONFIGURATION</title>
+
+	<para>
+		When used atop <command>vfs_ceph</command>,
+		<command>path</command> refers to an absolute path within the
+		Ceph filesystem and should not be mounted locally:
+	</para>
+
+	<programlisting>
+		<smbconfsection name=3D"[share]"/>
+		<smbconfoption name=3D"vfs objects">ceph_snapshots ceph</smbconfoption>
+		<smbconfoption name=3D"path">/non-mounted/cephfs/path</smbconfoption>
+		<smbconfoption name=3D"kernel share modes">no</smbconfoption>
+	</programlisting>
+
+	<para>
+		<command>vfs_ceph_snapshots</command> can also be used atop a
+		kernel CephFS mounted share path, without
+		<command>vfs_ceph</command>. In this case Samba's default VFS
+		backend <command>vfs_default</command> is used:
+	</para>
+
+	<programlisting>
+		<smbconfsection name=3D"[share]"/>
+		<smbconfoption name=3D"vfs objects">ceph_snapshots</smbconfoption>
+		<smbconfoption name=3D"path">/mnt/cephfs/</smbconfoption>
+	</programlisting>
+</refsect1>
+
+<refsect1>
+	<title>OPTIONS</title>
+
+	<variablelist>
+		<varlistentry>
+		<term>ceph:snapdir =3D subdirectory</term>
+		<listitem>
+		<para>
+			Allows for the configuration of the special CephFS
+			snapshot subdirectory name. This parameter should only
+			be changed from the ".snap" default if the ceph.conf
+			<command>client snapdir</command> or
+			<command>snapdirname</command> mount option settings
+			are changed from their matching ".snap" defaults.
+		</para>
+		<para>
+			Default:
+			<smbconfoption name=3D"ceph:snapdir">.snap</smbconfoption>
+		</para>
+		<para>
+			Example:
+			<smbconfoption name=3D"ceph:snapdir">.snapshots</smbconfoption>
+		</para>
+		</listitem>
+		</varlistentry>
+	</variablelist>
+</refsect1>
+
+<refsect1>
+	<title>VERSION</title>
+
+	<para>
+		This man page is part of version &doc.version; of the Samba suite.
+	</para>
+</refsect1>
+
+<refsect1>
+	<title>AUTHOR</title>
+
+	<para>The original Samba software and related utilities
+	were created by Andrew Tridgell. Samba is now developed
+	by the Samba Team as an Open Source project similar
+	to the way the Linux kernel is developed.</para>
+
+</refsect1>
+
+</refentry>
diff --git a/docs-xml/wscript_build b/docs-xml/wscript_build
index 796b685c709..575fb702b46 100644
--- a/docs-xml/wscript_build
+++ b/docs-xml/wscript_build
@@ -72,6 +72,7 @@ vfs_module_manpages =3D ['vfs_acl_tdb',
                        'vfs_cap',
                        'vfs_catia',
                        'vfs_ceph',
+                       'vfs_ceph_snapshots',
                        'vfs_commit',
                        'vfs_crossrename',
                        'vfs_default_quota',
--=20
2.21.0.1020.gf2820cf01a-goog


--jRHKVT23PllUwdXP--
